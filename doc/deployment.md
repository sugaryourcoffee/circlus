# Deployment of Circlus
We want to deploy Circlus in stages. We first deploy to beta and then to 
production. We skip the staging server for now as we start with only a few
users.

To deploy we follow these steps

On the server

* Install PostgreSQL
* Create the database
* Install Ruby 2.2.1p85 and Rails 4.2.5
* Create a deployment directory
* Create a virtual host for Circlus
* Put environment variable `SECRET_KEY_BASE` to environment variable

On the development machine

* Install capistrano
* Add the hostname for circlus
* Create production configuration files
* Deploy the application

We refer to the deployment machine as *saltspring* and the server as *uranus*.
You can tell from the prompt like `uranus $` that we are on the server and when
we are on the develop machine it shows `saltspring $`.

## On the server
We now prepare the server.

### Install PostgreSQL
We follow the same steps installing PostgreSQL as we did on the development
machine therefore we show only the commands for installation

    uranus$ sudo vi /etc/apt/sources.list.d/pgdg.list
    deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main
    :wq
    uranus$ wget --quiet -O - \
    https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    uranus$ sudo apt-get update
    uranus$ sudo apt-get install postgresql-9.4 postgresql-contrib-9.4 \
    postgresql-server-dev-9.4

Next we set the password for postgreSQL

    uranus$ sudo -u postgres psql postgres
    postgres=# \password postgres
    Enter new password:
    Enter it again:
    postgres=# \q

Finally we create a circlus user with a password

    uranus$ sudo -u postgres psql postgres
    postgres=# CREATE ROLE circlus LOGIN PASSWORD 'secret_database_password'
    postgres-> CREATEDB;
    CREATE ROLE
    postgres=# \q

For more explanation on installing PostgreSQL see 
[doc/circlus-setup.md](doc/circlus-setup.md).

### Create the database
Now we create the database circlus

    uranus$ sudo -u postgres psql postgres
    postgres=# CREATE DATABASE circlus_production
    postgres-> OWNER = circlus;

### Install Ruby and Rails
We install Ruby and Rails in a Gemset. First we install the required Ruby 
version 2.2.1p85

    uranus$ rvm install 2.2.1
    uranus$ rvm use 2.2.1

Next we create a Gemset and switch to the gemset

    uranus$ rvm gemset create rails425
    urnaus$ rvm ruby-2.2.1@rails425

We now install the Rails into that Gemset

    uranus$ gem install rails --version 4.2.5 --no-ri --no-rdoc

Now we look for the version and confirm that everything is correctly installed.

    uranus$ ruby -v
    ruby 2.2.1p85 (2015-02-26 revision 49769) [x86_64-linux]
    uranus$ rails -v
    Rails 4.2.5

Everything o.k. to proceed.

### Create the deployment directory
We want to deploy to Apache's default deployment environment at `/var/www`. So
before we create the deployment directory we change the user rights to the
*deployers* group

    uranus$ sudo chgrp deployers /var/www
    uranus$ suod chmod g+w /var/www

Now we create our deployment directory with

    uranus$ sudo mkdir /var/www/cirlus

### Port configuration for circlus
We have several applications running on uranus therefore we need to provide a
port over that circlus can be accessed. We do that in `/etc/apache2/ports.conf`.

    Listen 8085

This entry makes circlus available on port *8084*.
   
### Create a virtual host for circlus
We configure Apache 2 to find Circlus by providing a virtual host in
`/etc/apache2/sites-avaiable/circlus.conf`

    <VirtualHost *:8085>
      Servername circlus.uranus
      DocumentRoot /var/www/circlus/current/public
      PassengerRuby /home/pierre/.rvm/gems/ruby-2.2.1@rails425/wrappers/ruby
      <Directory /var/www/circlus/public>
        AllowOverride all
        Options -MultiViews
        Require all granted
      </Directory>
      RackEnv production
    </VirtualHost>
    
We enable the virtual host with

    uranus$ sudo a2ensite circlus.conf

and reload the configuration and restart Apache 2

    uranus$ service apache2 reload && sudo apachectl restart

### Environment variable with `CIRCLUS_DATABASE_PASSWORD`
We have to add the `CIRCLUS_DATABASE_PASSWORD` variable to `/etc/environments`

    export CIRCLUS_DATABASE_PASSWORD=secret_database_password
    ruby -e 'p ENV["CIRCLUS_DATABASE_PASSWORD"]'

That's it almost for the server. We come back when we have to save the database
password in an environment variable.

## On the development machine
We now prepare the development machine for deployment.

### Install Capistrano
As we are using RVM we add following to our Gemfile

    group :development do
      gem 'capistrano'
      gem 'capistrano-bundler'
      gem 'capistrano-rails'
      gem 'capistrano-rvm'
    end

Next we install the capistrano gems with

    saltspring$ bundle install

Next we create the capistrano configuration files with

    saltspring$ capify .

Then we configure the `Capfile`

and configure `config/deploy/production.rb`

    set :domain 'circlus.uranus'

    role :app, [domain]
    role :web, [domain]
    role :db,  [loacalhost], primary: :true


We use differnt databases dependent on the stage we are add. For production the
content of confg/database.yml should look like this

    production:
      <<: *default
      database: circlus_production
      username: circlus
      pasword: <%= ENV['CIRCLUS_DATABASE_PASSWORD'] %>

The circlus password will be saved on the server as an environment variable. We
do that as follows back on the server.

    uranus$ sudo vi /etc/environment

and add

    export CIRCLUS_DATABASE_PASSWORD='secret_database_password'
    ruby -e 'p ENV["CIRCLUS_DATABASE_PASSWORD"]'

Back on the console we issue

    uranus$ source /etc/environment

and check whether the environment variable is available

    uranus$ printenv | grep CIRC
    CIRCLUS_DATABASE_PASSWORD=secret_database_password

### Add circlus as a hostname
In `/etc/hosts` we add the circlus hostname

    192.168.178.66 ... cirlcus.uranus

### Deployment
Now we are ready to deploy our application. To do that we process following
commands

    saltspring$ cap production deploy:setup
    saltspring$ cap production deploy:check

If everything runs without errors we do our first deployment

    saltspring$ cap production deploy:cold

For subsequent deploys we just do

    saltspring$ cap production deploy

and if we made changes to the database we run

    saltspring$ cap prodcution deploy:migrations



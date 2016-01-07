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

### Environment variable with `SECRET_KEY_BASE`
We have to add the `SECRET_KEY_BASE` variable to `/etc/environments`

    export SECRET_KEY_BASE=secret_key_base
    ruby -e 'p ENV["SECRET_KEY_BASE"]'

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
      gem 'capistrano-passenger'
    end

Next we install the capistrano gems with

    saltspring$ bundle install

We will get a release message for *capistrano-passenger*

    ==== Release notes for capistrano-passenger ====
    passenger once had only one way to restart: `touch tmp/restart.txt`
    Beginning with passenger v4.0.33, a new way was introduced: 
    `passenger-config restart-app

    The new way to restart was not initially practical for everyone,
    since for versions of passenger prior to v5.0.10,
    it required your deployment user to have sudo access for some server 
    configurations.

    capistrano-passenger gives you the flexibility to choose your restart 
    approach, or to rely on reasonable defaults.

    If you want to restart using `touch tmp/restart.txt`, add this to your 
    config/deploy.rb:

        set :passenger_restart_with_touch, true

    If you want to restart using `passenger-config restart-app`, add this to 
    your config/deploy.rb: 

        set :passenger_restart_with_touch, false # Note that `nil` is NOT the 
                                                 # same as `false` here
                                                                                
    If you don't set `:passenger_restart_with_touch`, capistrano-passenger will
    check what version of passenger you are running                             
    and use `passenger-config restart-app` if it is available in that version.
                                                                                
    If you are running passenger in standalone mode, it is possible for you to 
    put passenger in your Gemfile and rely on capistrano-bundler to install it 
    with the rest of your bundle.                                               
    If you are installing passenger during your deployment AND you want to 
    restart using `passenger-config restart-app`, you need to set 
    `:passenger_in_gemfile` to `true` in your `config/deploy.rb`.
    ================================================

### Configure Capistrano
Next we create the capistrano configuration files with

    saltspring$ cap install
    mdkir -p config/deploy
    create config/deploy.rb
    create config/deploy/staging.rb
    create config/deploy/production.rb
    mkdir -p lib/capistrano/tasks
    create Capfile
    Capified

Then we configure the `Capfile`. We just have to uncomment following 
`require` statements

    require 'capistrano/rvm'
    # require 'capistrano/rbenv'
    # require 'capistrano/chruby'
    require 'capistrano/bundler'
    require 'capistrano/rails/assets'
    require 'capistrano/rails/migrations'
    require 'capistrano/passenger'

In `config/deploy.rb` we set the variable as shown below

    set :application, 'circlus'
    set :repo_url, 'git@github.com:sugaryourcoffee/circlus.git'
    set :deploy_to, '/var/www/circlus'

and configure `config/deploy/production.rb`. We add following two lines

    set :stage, :production
    set :rails_env, 'production'
    set :rvm_ruby_version, '2.2.1@rails425'
    set :rvm_type, :user


and uncomment and adjust the sequence below

    role :app, %w{circlus.uranus}
    role :web, %w{circlus.uranus}
    role :db,  %w{circlus.uranus}, primary: :true

    server 'circlus.uranus',
      user: 'pierre',
      group: 'pierre',
      roles: %w{web app db},
      ssh_options: {
        user: 'pierre', # overrides user setting above
        keys: %w(~/.ssh/id_rsa),
        forward_agent: true,
    }

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

    saltspring$ cap production deploy

If everything runs without errors we do our first deployment. We are done. If 
not we can rollback with

    saltspring$ cap production deploy:rollback

if we have previous versions that worked and check for errors.

We can check if the gemset is avaialable with

    saltspring$ cap production rvm:check

#### Deployment errors
This section describes some errors that may occur and how to solve them.

##### Devise secret key

    DEBUG [08842252]        rake aborted!                                       
    Devise.secret_key was not set. Please add the following to your Devise 
    initializer:                                                                

      config.secret_key = '14da784741dc04de1ccad159f76d45a28f87f0cc2b5dfa42fb3edaa7eb75354b4ae1621911045cb48651e3bf6566179efb1382a6713a3eeedc5590cbf3fa806a'

    Please ensure you restarted your application after installing Devise or 
    setting the key.

##### DEBUG [2e39127e] Command: /usr/bin/env which passenger 

    DEBUG [2e39127e] Finished in 0.411 seconds with exit status 1 (failed).

##### DEBUG [eaea3e31] Command: [ -f /var/www/circlus/current/REVISION ]

    DEBUG [eaea3e31] Finished in 0.013 seconds with exit status 1 (failed).

##### DEBUG [2f634ea2] Command: [ -f /var/www/circlus/repo/HEAD ]

    DEBUG [2f634ea2] Finished in 0.013 seconds with exit status 1 (failed).

#####  DEBUG rails assets

    DEBUG [e78e0a13] Command: [ -L /var/www/circlus/releases/20160106215120/public/assets ]
    DEBUG [e78e0a13] Finished in 0.021 seconds with exit status 1 (failed).

##### DEBUG [89837098] Command: [ -d /var/www/circlus/releases/20160106215120/public/assets

    DEBUG [89837098] Finished in 0.020 seconds with exit status 1 (failed).

##### Passenger not found

    DEBUG [e0c03bfa] Running ~/.rvm/bin/rvm 2.2.1@rails425 do passenger -v as 
    pierre@circlus.uranus                                                       
    DEBUG [e0c03bfa] Command: cd /var/www/circlus/releases/20160106230217 && 
    ~/.rvm/bin/rvm 2.2.1@rails425 do passenger -v                               
    DEBUG [e0c03bfa]        /home/pierre/.rvm/scripts/set: line 19: 
    exec: passenger: not found


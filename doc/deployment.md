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
* Set `SECRET_KEY_BASE`, `SECRET_TOKEN` 

On the development machine

* Install capistrano
* Add the hostname for circlus
* Create production configuration files
* Add secret token and secret key base to `config/secret.yml`
* Deploy the application
* Open port on router for external access

We refer to the deployment machine as *saltspring* and the server as *uranus*.
You can tell from the prompt like `uranus $` that we are on the server and when
we are on the develop machine it shows `saltspring $`.

## On the server
First we start to prepare the server.

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

Everything is o.k., so we can to proceed.

### Create the deployment directory
We want to deploy to Apache's default deployment environment at `/var/www`. So
before we create the deployment directory we change the user rights to the
*deployers* group

    uranus$ sudo chgrp deployers /var/www
    uranus$ sudo chmod g+w /var/www

Now we create our deployment directory with

    uranus$ sudo mkdir /var/www/cirlus

### Port configuration for circlus
We have several applications running on uranus therefore we need to provide a
port over that circlus can be accessed. We do that in `/etc/apache2/ports.conf`.

    Listen 8084

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
    </VirtualHost>
    
We enable the virtual host with

    uranus$ sudo a2ensite circlus.conf

and reload the configuration and restart Apache 2

    uranus$ service apache2 reload && sudo apachectl restart

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

The next entry is important and only necessary if you have multiple Rails
applications running with differnt Ruby versions. We use Ruby 2.2.1 but 
Passenger was installed under Ruby 2.0.0 in the gemset rails401. In order
Capistrano will find Passenger we have to set the variable as shown

    set :passenger_rvm_ruby_version, '2.0.0@rails401'

Dependent on the version of Passenger you may use passenger-config restart-app
to restart the application after deploy. But in our case we use the touch 
restart process

    set :passenger_restart_with_touch, true

    set :deploy_to, '/var/www/circlus'

and configure `config/deploy/production.rb`. We add following lines

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

We use differnt databases dependent on the stage we are at. For production the
content of confg/database.yml should look like this

    production:
      <<: *default
      database: circlus_production
      username: circlus
      pasword: very_secret_password

We of course don't want to have `config/database.yml` deployed to Github with
our secret password. How to prevent that is described at *Keep your secrets*.

### Add secrets
Since Rails 4 secret values are kept in `config/secret.yml`. In order the 
application will actually run we have to create secret tokens. To create a
secret token we can use rake with

    saltspring$ rake secret RAILS_ENV.production
    826b81011b1a4672507b65a8d076b6ebd136c5f0d8e3a2b73...

we add the generated token to `config/secrets.yml` to `secret_key_base` and
`secret_token`.

    production:
      secret_key_base: 826b81011b1a4672507b65a8d076b6ebd136c5f0d8e3a2b73...
      secret_token: 826b81011b1a4672507b65a8d076b6ebd136c5f0d8e3a2b73...

Devise also uses a secret key. We have to add our token to 
`config/intializers/devise.rb`

    Devise.setup do |config|
      # other variables
      config.secret_key = '82e6b232deab814c71e1753bc8f80aa311b4d10663613d1...'
      # other variables
    end
   
In order to prevent publishing our secret tokens we have to avoid pushing 
these files to Github. How to do that is shown in the next section.

### Keep your secrets
We don't want to push our `config/database.yml`, our `config/secrets.yml` and
our `config/initializers/devise.rb` to Github because they will contain secret
tokens as we see in the next section *Add secrets*. In order to achieve that 
we have to proceed as follows.

    saltspring$ echo config/database.yml >> .gitignore
    saltspring$ mv config/database.yml{.example}
    saltspring$ echo config/secrets.yml >> .gitignore
    salstpring$ mv config/secrets.yml{.example}
    saltspring$ echo config/initializers/devise.rb >> .gitignore
    saltspring$ mv config/initializers/devise.rb{.example}

What we did is renaming the files with secret tokens to `*.example` and put the 
original filename to .gitignore. Now we commit our changes and push the 
example files to Github. Now we can change the files back to the orginial 
filenames and change or add our secret tokens in the files. Subsequent Githup
pushes won't reveal our secrets.

The problem now is when we deploy our application  our secret files won't get 
copied. To fix that we have to copy the files to the server from our 
development respectively our deployment machine. We have to add following to
our `config/deployment.rb`

     set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/initializers/devise.rb')

   Then we have to copy these files from our development machine to the server
into the `config/` and `config/inititializers` directory.

During deployment these files get linked into the current directory.

### Add circlus as a hostname
In `/etc/hosts` we add the circlus hostname

    192.168.178.66 ... cirlcus.uranus

... stands for already available entries if any.

### Deployment
Now we are ready to deploy our application. To do that we process following
commands

    saltspring$ cap production deploy

If everything runs without errors we are done. If not we can rollback with

    saltspring$ cap production deploy:rollback

if we have previous versions that worked and then check for errors.

We want to do a sanity check if the gemset is available, we can do so with

    saltspring$ cap production rvm:check

No we can check up our application at
[http://circlus.uranus:8048](http://circlus.uranus:8084).

#### Deployment errors
This section describes some errors that may occur and how to solve them.

##### Devise secret key

    DEBUG [08842252]        rake aborted!                                       
    Devise.secret_key was not set. Please add the following to your Devise 
    initializer:                                                                

      config.secret_key = '14da784741dc04de1ccad159f76d45a28f87f0cc2b5dfa42fb3edaa7eb75354b4ae1621911045cb48651e3bf6566179efb1382a6713a3eeedc5590cbf3fa806a'

    Please ensure you restarted your application after installing Devise or 
    setting the key.

Just follow the advice from Devise which is also explained in *Add secrets*.

##### DEBUG [2e39127e] Command: /usr/bin/env which passenger 

    DEBUG [2e39127e] Finished in 0.411 seconds with exit status 1 (failed).

This is actually no error. This will be resolved by *capistrano/passenger* 
when we `set :passenger_rvm_ruby_version, '2.0.0@rails401'` in 
`config/deploy.rb`.

##### DEBUG [eaea3e31] Command: [ -f /var/www/circlus/current/REVISION ]

    DEBUG [eaea3e31] Finished in 0.013 seconds with exit status 1 (failed).

This is no bug, the test just failed and Capistrano knows that the file is not
available.

##### DEBUG [2f634ea2] Command: [ -f /var/www/circlus/repo/HEAD ]

    DEBUG [2f634ea2] Finished in 0.013 seconds with exit status 1 (failed).

This is no bug, the test just failed and Capistrano knows that the file is not
available.

#####  DEBUG rails assets

    DEBUG [e78e0a13] Command: [ -L /var/www/circlus/releases/20160106215120/public/assets ]
    DEBUG [e78e0a13] Finished in 0.021 seconds with exit status 1 (failed).

This is no bug, the test just failed and Capistrano knows that the file is not
available.

##### DEBUG [89837098] Command: [ -d /var/www/circlus/releases/20160106215120/public/assets

    DEBUG [89837098] Finished in 0.020 seconds with exit status 1 (failed).

This is no bug, the test just failed and Capistrano knows that the file is not
available.

##### Passenger not found

    DEBUG [e0c03bfa] Running ~/.rvm/bin/rvm 2.2.1@rails425 do passenger -v as 
    pierre@circlus.uranus                                                       
    DEBUG [e0c03bfa] Command: cd /var/www/circlus/releases/20160106230217 && 
    ~/.rvm/bin/rvm 2.2.1@rails425 do passenger -v                               
    DEBUG [e0c03bfa]        /home/pierre/.rvm/scripts/set: line 19: 
    exec: passenger: not found

This is actually an error most probably in the Gemset where Passenger is 
installed which is screwed up or you didn't 
`set :passenger_rvm_ruby_version, '2.0.0@rails401'` in `config/deploy.rb`.
Another possibility is that you don't have write access to 
`/var/wwww/circlus/shared/` or subfolders.

#### Capfile locked at 3.4.0, but 3.5.0 is loaded
In `config/deploy.rb` a lock to the capistrano version is set to 3.4.0. But you
have updated capistrano to 3.5.0. In order to deploy you eather have to remove
the lock in `config/deploy.rb` or change it to the loaded version like so

    lock '3.5.0'

#### Apache/Passenger Errors

##### Incomplete response received from application
If this error occurs this is most likely because you have missed to set eather
the `SECRET_TOKEN` or `SECRET_KEY_BASE` or both. See *Add secrets*

You can view the detailed error messages in `/var/log/apache2/error.log`.


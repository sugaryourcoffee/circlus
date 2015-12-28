# Installation
In the Circlus application we will use

* Ruby and Ruby on Rails
* PostgreSQL as the database
* Devise for authentication
* Bower for front-end assets
* AngularJS
* Bootstrap for CSS
* Install RSpec, Poltergeist/Capybara, DatabaseCleaner, PhantomJS and 
  Teaspoon/Jasmine 

The development machine is driven by Ubuntu 14.04LTS, so all installation 
instructions that are operating system specific relate to Ubuntu.

## Install latest Ruby and Rails
First we make sure we have the latest RVM version

    $ rvm get stable

Then we check for the latest Ruby version

    $ rvm list known
    [ruby-]2.2

We install Ruby 2.2

    $ rvm install 2.2

and select it

    $ rvm ruby-2.2

Next we want to install the latest Rails version. We first check the Rails
versions available

    $ gem list ^rails$ -ra
    rails (4.2.5, 4.2.4, ...)

We create a gemset where we want to install Rails to

    $ rvm create gemset rails425
    $ rvm ruby-2.2.4@rails425
    $ gem install rails --no-ri --no-rdoc

Without providing an explicit version `gem install rails` will install the 
latest Rails version.

## Install PostgreSQL
In the application we want to use PostgreSQL as the database. We check if it 
is installed and which version is installed. We also want to have the latest
version here. To look up the latest version of PostgreSQL we go to 
[http://www.postgresql.org](http://www.postgresql.org). There it reads by the
time of this writing version 9.4. If we search in our version of Ubuntu 14.04LTS
we get the version 9.3.

    $ sudo apt-cache search postgresql-9
    postgresql-9.3 - object-relational SQL database, version 9.3 server

In order to install version 9.4 we may add the postgresql repository. How to do
that can be also found at [Linux downloads (Ubuntu)](http://www.postgresql.org/download/linux/ubuntu/)
and background about adding repostitories is described at [Repositories/CommandLine](https://help.ubuntu.com/community/Repositories/CommandLine).

Add following to `/etc/apt/sources.list.d/pgdg.list`

    deb http://apt.postgres.org/pub/repos/apt/ trusty-pddg main

Import the repository signing-key

    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -

Then update the package list, look for postgres-9.4 and install

    $ sudo apt-get update
    $ sudo apt-cache search postgres-9.4
    $ sudo apt-get install postgres-9.4 postgresql-contrib-9.4 \
    postgresql-server-dev-9.4

`postgresql-server-dev-9.4` is needed during the generation of our Rails 
applicaton.

As a first step we need to set the password
(see also [PostgreSQL Ubuntu Wiki](https://help.ubuntu.com/community/PostgreSQL)
for the *postgres* user.

    $ sudo -u postgres psql postgres
    postgres=# \password postgres
    Enter new password:
    Enter it again:
    postgres=# \q

In order we can access postgresql from Rails we will create a circlus user 
with a password.

    $ sudo -u postgres psql postgres
    postgres=# CREATE ROLE circlus LOGIN PASSWORD 'secret' CREATEDB;
    CRATE ROLE
    postgres=# \q


This command will create a role *circlus* that is allowed to create databases 
`CREATEDB` and `LOGIN` will tell postgres that the user is allowed to login to 
the database.

# Craete the Circlus application
We create the application without ri and rdoc. We also don't want to use 
sprocket in favor of AngularJS.

    $ rails new circlus --skip-turbolinks \
                        --skip-spring \
                        --skip-test-unit \
                        -d postgresql

Now we change directory to our newly created circlus application directory.

##Configure config/database.yml
In order to create and access PostgreSQL database we need to add the username
and password to `config/database.yml`.

    default: &default
      adapter: postgresql
      encoding: unicode
      host: localhost
      username: circlus
      password: secret
      pool: 5

Next we create the database with

    $ rake db:create
    $ rake db:migrate

then start your Rails server

    $ rails s

and goto [http://localhost:3000](http://localhost:3000) where you should see
the default Rails welcome screen.

# Install Devise
Devise is used for user authentication. To install it we add to the Gemfile

    gem 'devise'

and then we run

    $ bundle install
    $ rails g devise:install

This will provide some information

    Some setup you must do manually if you haven't yet: 

      1. Ensure you have defined default url options in your environments files.
         Here is an example of default_url_options appropriate for a development
         environment in config/environments/development.rb:

           config.action_mailer.default_url_options = { host: 'localhost', 
                                                        port: 3000 }

         In production, :host should be set to the actual host of your 
         application. 

      2. Ensure you have defined root_url to *something* in your 
         config/routes.rb.  

         For example:

           root to: "home#index"

      3. Ensure you have flash messages in 
         app/views/layouts/application.html.erb.  

         For example:

           <p class="notice"><%= notice %></p>
           <p class="alert"><%= alert %></p>

      4. If you are deploying on Heroku with Rails 3.2 only, you may want to 
         set:

           config.assets.initialize_on_precompile = false

         On config/application.rb forcing your application to not access the DB
         or load models when precompiling your assets.

      5. You can copy Devise views (for customization) to your app by running:

           rails g devise:views        

Devise comes with a generator for creating an user model. We will use that with

    $ rails g devise user

In order to restrict access to registered in logged in users only we have to add
the `authenticate_user!` filter, that comes with Devise, to the 
`ApplicationController`. Note that this will prevent access of anonymous users
on all circlus pages. If we want to have pages we want to allow access to by
anonymous users we have to skip the filter in the respective controller or 
actions. For now we add `authenticate_user!` to the `ApplicationController`.

    before_action :authenticate_user!

We have to restart our Rails server in order to activate the changes.

    $ CTRL-C
    $ rails s

We can also view the database with

    $ rails dbconsole
    Password:

To enter the database console we have to enter the password we have provided in
`config/database.yml` for the circlus database.

Devise views are not accessible at first. But if we want to style them we have
to extract them to our application. We can do this with

    $ rails generate devise:views

## Install Bower
Bower manages front-end assets like Bootstrap or AngularJS. To install Bower we
need install NodeJS which is probably already available. With NodeJS comes the
npm package manager. We can install NodeJS from the Ubuntu repository

    $ sudo apt-get install nodejs

To install Bower we do

    $ sudo npm install -g bower

This will install Bower in global mode (`-g`) and install it in 
`/usr/local/lib/node_modules/bower` which needs root access.

We also want to install `bower-rails` to interact with Bower on the command line
with Rake instead of using the Bower command line interface directly. So add to 
the Gemfile

    gem 'bower-rails'

and run

    $ bundle install

## Install Boostrap
To ease CSS styling we rely on the CSS library Bootstrap so we don't have to
write rarely any CSS. We can search for Bootstrap with Bower

    $ bower search bootstrap | grep -P "^\s*bootstrap"

    bootstrap git://github.com/twbs/bootstrap.git
    bootstrap-sass-official git://github.com/twbs/bootstrap-sass.git
    bootstrap-datepicker git://github.com/eternicode/bootstrap-datepicker.git
    bootstrap-select git://github.com/silviomoreto/bootstrap-select.git
    bootstrap-daterangepicker git://github.com/dangrossman/\
    bootstrap-daterangepicker.git
    bootstrap-timepicker git://github.com/jdewit/bootstrap-timepicker
    bootstrap-switch git://github.com/nostalgiaz/bootstrap-switch.git
    bootstrap-css git://github.com/jozefizso/bower-bootstrap-css.git
    bootstrap-multiselect git://github.com/davidstutz/bootstrap-multiselect.git
    bootstrap.css git://github.com/bowerjs/bootstrap.git
    bootstrap-datetimepicker git://github.com/tarruda/\
    bootstrap-datetimepicker.git
    bootstrap-modal git://github.com/jschr/bootstrap-modal.git
    bootstrap-tour git://github.com/sorich87/bootstrap-tour.git
    bootstrap-tagsinput git://github.com/TimSchlechter/bootstrap-tagsinput.git
    bootstrap-additions git://github.com/mgcrea/bootstrap-additions.git
    bootstrap-file-input git://github.com/grevory/bootstrap-file-input.git
    bootstrap-social git://github.com/lipis/bootstrap-social.git

As Rails is working with Sass we use the second one in the list and add it to a
file called `Bowerfile` analogous to the Gemfile

    asset 'bootstrap-sass-official

Now we run the Rake task to install Bower

    $ rake bower:install

In order Bootstrap is considered when Rails is creating `application.css` we 
need to tell it to include Bootstrap. This is done in 
`app/assets/stylesheets/application.css`

    /*
     *= require_tree .
     *= require_self
     *= require 'bootstrap-sass-official'
     */

In order to see the new Bootstrap styles we have to restart our Rails server.

## Install AngularJS
AngularJS is a JavaScript framework we want to utilize in our application which
is easier to use than pure JQuery.

We install AngularJS with Bower. To do so we add following line to the 
`Bowerfile`

    asset 'angular', '~> 1.5'
    resolution 'angular', '1.5'

Then run

    $ rake bower:install

Next we require AngularJS in `app/assets/javascripts/application.js`

    //= require angular
    //= require_tree .

## Install RSpec, Poltergeist/Capybara, PhantomJS and Teaspoon/Jasmine
We will use RSpec for our Ruby tests, Capibara and Poltergeist for our view
tests and Jasmine for JavaScript tests.

### Install RSpec
In the Gemfile add RSpec like so

    group :development, :test do
      ...
      gem 'rspec-rails', '-> 3.0'
    end

Now install RSpec with 

    bundle install

Next run the configuration to activate RSpec

    rails g rspec:install

Make some configurations to `spec/spec_helper.rb` as shown in
[spec/spec_helper.rb](../spec/spec_helper.rb)

### Install PhantomJS
PhantomJS is a headless browser that we can use to test AJAX-driven web sites.
At the time of this writing there is no binary available therefore we have to
build it ourself. The download page can be found at 
[PhantomJS Documentation](http://phantomjs.org/download.html). Instructions to
build can be found at [PhantomJS Build](http://phantomjs.org/build.html)
 
Frist download the source at 
[PhantomJS Documentation](http://phantomjs.org/download.html)

Then unzip with

    $ mkdir PhantomJS
    $ unzip phantomjs-2.0.0-source.zip -d PhantomJS
    $ cd PhantomJS

Then install the development packages

    $ sudo apt-get install build-essential g++ flex bison gperf ruby perl \
    > libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
    > libpng-dev libjpeg-dev python libx11-dev libxext-dev

You probably already have some of the packages installed and only the missing
packages get installed then.

Then start the build process

    $ git clone --recurse-submodules git://github.com/ariya/phantomjs.git
    $ cd phantomjs
    $ ./build.py

This will take depending on the machine several minutes. Then you are asked
whether to start the make process with a warning about the process taking 30
minutes and more. Press `Y` to start and go watch a movie or read a book.

After roughly 50 minutes the build was finished. Next step is to put the 
`bin/phantomjs` to your path

    $ sudo ln -s ~/Files/phantomjs/bin/phantomjs /usr/local/bin/phantomjs

Now we check whether PhantomJS is working

    $ phantomjs
    phantomjs> phantom.version
    {
      "major": 2,
      "minor": 0,
      "patch": 0
    }
    phantomjs> phantom.exit()
    $

### Install Poltergeist/Capibara
Poltergeist will also install Capibara. Poltergeist is a driver for Capybara and
is used to run Capybara test in combination with PhantomJS.

First we add Poltergeist to our Gemfile

    group :development, :test do
      # ...
      gem 'rspec-rails', '~> 3.0'
      gem 'poltergeist'
    end

Then we install it with

    $ bundle install

In order to use capybara and poltergeist we have to add some configuraton to
[spec/rails_helper.rb](../spec/rails_helper.rb)

    require 'rspec/rails'
    require 'capybara/poltergeist'

    Capybara.javascript_driver = :poltergeist

### Install Database Cleaner
The RSpec Rails tests and the PhantomJS test run in two different processes.
That is the data saved to the database in our Rails tests aren't visible to our
PhantomJS tests. Therefore we have to save the data to the database and clean
it between test runs. This is where DatabaseCleaner comes into play.

We add DatabaseCleaner to our Gemfile

    group :development, :test do
      # ...
      gem 'rspec-rails', '~> 3.0'
      gem 'poltergeist'
      gem 'database_cleaner'
    end

Then we run

     $ bundle install

Next we configure DatabaseCleaner so it looks like in
[spec/rails_helper.rb](../spec/rails_helper.rb)

### Install Jasmine and Teaspoon
We use Jasmine to test JavaScript. We use Jasmine together with Teaspoon which
is a JavaScript test runner built for Rails.

We add to our Gemfile

    group :development, :test do
      # ...
      gem 'rspec-rails', '~> 3.0'
      gem 'poltergeist'
      gem 'database_cleaner'
      gem 'teaspoon-jasmine'
    end

Then run

    $ bundle install

After we installed it we set it up with

    $ rails g teaspoon:install

# Next steps
Now we are all setup and can start building our application. Notes on the 
application design can be found at [design-notes.md](design-notes.md).

# Resources

* [Rails, Angular, Postgres, and Bootstrap by David Bryant Copeland](https://pragprog.com/book/dcbang/rails-angular-postgres-and-bootstrap)
* [PostgreSQL - Up and Running by Regina Obe & Leo Hsu](http://shop.oreilly.com/product/0636920032144.do)
* [http://www.postgresql.org](http://www.postgresql.org)
* [PostgreSQL Ubuntu Wiki](https://help.ubuntu.com/community/PostgreSQL)
* [PostgreSQL Linux downloads (Ubuntu)](http://www.postgresql.org/download/linux/ubuntu/)
* [PhantomJS Documentation](http://phantomjs.org/download.html)
* [PhantomJS Build](http://phantomjs.org/build.html)
* [Repositories/CommandLine](https://help.ubuntu.com/community/Repositories/CommandLine).


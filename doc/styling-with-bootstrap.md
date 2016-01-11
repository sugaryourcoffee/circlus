# Styling with Bootstrap
This document provides some notes on how to use Bootstrap and HTML.

## Bootstrap JavaScript
We have installed Bootstrap not with bundle but with bower. Bower stores the
assets to `vendor/assets/bower_components/`. But this is not a place where 
assets are loaded automatically through the asset pipeline.

To use Bootstrap's JavaScript libraries they need to be required with full path.
In `app/assets/javascripts/application.js` a `require` looks like so

    //= require bootstrap-sass-official/assets/javascripts/bootstrap/dropdown

Note: There is obviously a better way but currently I don't have no clue.

## Container
In order the web page is layed out corresponding the Bootstrap layout we need
to put the page content into a `container` class

    <div class="container">
       ...
    </div>

Otherwise the page content will be left aligned and not shifted to the page
area defined by Bootstrap.

## Navbar fixed-to-top
When fixing the Navbar to the top we need to add a custom CSS to add a padding
to the top. Otherwise the content will be overlayed by the Navbar.

To do this we create `app/assets/stylesheets/custom.css.scss` and add

    body {
      padding-top: 60px;
    }

## Glyphicons
Glyphicons that come with bootstrap and are free to use icons. We can use them
by prepending them to a value

    <i class="glyphicon glyphicon-user"></li>
    <%= member.name %>

However they won't be displayed in a deployed application. To achieve the 
correct display of glyphicons we have to tweak our setup.

## Meta tags for responsiveness
Bootstrap has responsiveness built in. With just some meta tags in the `<head>`
of your document websites on a mobile phone look (almost) like native apps.

Right after `<head>` you need to add these meta tags

    <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      ...
    </head>

## Make Google Chrome on Android app 'Add to Homescreen'
To make the menu item on Android in Google Chrome active you have to add the
meta tag `mobile-web-app-capable` to the `<head>`

    <meta name="mobile-web-app-capable" content="yes">

### Make Glyphicons display in production
To get glyphicons displayed is a little bit involved. We have to

* move application.css to scss
* replace require with @import in application.scss
* set the assets path in application.rb

First we do

    saltspring$ mv app/assets/stylesheets/application.css \
    > app/assets/stylesheets/application.scss

Next we replace the `*= require` with `@import` in 
[application.sccs](app/assets/stylesheets/application.sccs). We have to make
sure that the imports of bootstrap come at the end, otherwise these would 
override our paddings for footer and header.

    /*
     * require_tree .
     * require_self
     */
    //START_HIGHLIGHT
    @import "bootstrap-sass-official/assets/stylesheets/bootstrap-sprockets";
    @import "bootstrap-sass-official/assets/stylesheets/bootstrap";
    //END_HIGHLIGHT    

Finally we have to tweak [config/application.rb](config/application.rb)

    config.assets.paths << Rails.root.join("vendor",
                                           "assets",
                                           "bower_components",
                                           "bootstrap-sass-official",
                                           "assets",
                                           "fonts")
    config.assets.precompile << /\.(?:svg|eot|woff|ttf|woff2)\z/

## Responsive Header and Footer
On mobile devises or if the screen width is below a certain size it will 
collapse the header which overlays the content. In order to toggle the header
and footer we have to use bootstrap's collapse.js.

In 
[app/assets/javascripts/application.js](app/assets/javascripts/application.js)
we require

    //= require bootstrap-sass-official/assets/javascripts/bootstrap/collapse

In [app/views/layouts/\_header.html.erb](app/views/layouts/\_header.html.erb) 
we add following code

    <header class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <nav>
          <button type="button" class="navbar-toggle collapsed"
            data-toggle="collapse" data-target="#collapsable-navbar"
            aria-expanded="false">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>

          <%= link_to "Circlus", root_path, class: "navbar-brand" %>

          <div class="collapse navbar-collapse" id="collapsable-navbar">
            <ul class="nav navbar-nav navbar-right">
              ...
            </ul>
          </div>
        </<div>
      </header>
     
We add the same code snippet to the footer except for the id.

    <footer class="navbar navbar-inverse navbar-fixed-bottom">
      <div class="container">
        <button type="button" class="navbar-toggle collapsed"
          data-toggle="collapse" data-target="#collapsable-footer"
          aria-expanded="false">
          <span class="sr-only">Toggle footer navigation</span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>

        <div class="collapse navbar-collapse" id="collapsable-footer">
          <ul class="nav navbar-nav">
            <li>
              <a href="https://github.com/sugaryourcoffee/circlus", 
                target="_blank">
                Circlus <%= "0.0.1" %> by Sugar Your Coffee
              </a> 
            </li>
          </ul>
          <ul class="nav navbar-nav navbar-right">
            <li><%= link_to 'Terms of Use', "#" %></li>
            <li><%= link_to 'About Us', about_path %></li>
            <li><%= link_to 'Contact', "#" %></li>
          </ul>
        </div>
      </div>
    </footer>

## Make phone numbers clickable
Most known links are `mailto:` and regualar URIs. But we can make phone numbers
clickable with `tel:`.

     "<a href=\"tel:+12345678"> +1 (234) 5678</a>" 
   

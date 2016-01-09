# Styling with Bootstrap
This document provides some notes on how to use Bootstrap

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

### Make Glyphicons display in production
To get glyphicons displayed is a little bit involved. We have to

* move application.css to scss
* replace require with @import in application.scss
* set the assets path in application.rb

First we do

    saltspring$ mv app/assets/stylesheets/application.css \
    > app/assets/stylesheets/application.scss

Next we replace the `*= requier` with `@import` in 
[application.sccs](app/assets/stylesheets/application.sccs)

    //START_HIGHLIGHT
    @import "bootstrap-sass-official/assets/stylesheets/bootstrap-sprockets";
    @import "bootstrap-sass-official/assets/stylesheets/bootstrap";
    //END_HIGHLIGHT    
    /*
     * require_tree .
     * require_self
     */

Finally we have to tweak [config/application.rb](config/application.rb)

    config.assets.paths << Rails.root.join("vendor",
                                           "assets",
                                           "bower_components",
                                           "bootstrap-sass-official",
                                           "assets",
                                           "fonts")
    config.assets.precompile << /\.(?:svg|eot|woff|ttf|woff2)\z/


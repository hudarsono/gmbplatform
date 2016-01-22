# GopherGMB README

* Ruby version : v2.2.3

## Database creation
```ruby
rake db:create
rake db:migrate
```

## Database initialization
```ruby
rake db:seed
```

## Local development setup
* Configure ~/.bash_profile to include following variables :
  - GMB_OAUTH2_CLIENT_ID
  - GMB_OAUTH2_CLIENT_SECRET
  You may get that information from Gopher GBM project in Google developer console. Please use the "localhost" credentials
* Run the server on port 3050  : rails s -p3050

## Authorization 
* Login to GopherGMB with default admin user. Please see db seed for default user
* Click on "authorize" key to get access token.

## Enjoy!

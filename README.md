# Totem - Activerecord

This gem is the ActiveRecord add-on for [Totem](https://github.com/chadrem/totem).

## Installation

Add this line to your Totem project's Gemfile:

    gem 'totem_activerecord'

And then execute:

    $ bundle

## Setup

You will need setup this gem the first time you use it in a project.

Create a `config/database.yml` (example for MRI + MySQL + Activerecord 3.x below):

    development:
      adapter: mysql2
      database: my_app_dev
      username: root
      reconnect: true
      timeout: 5000
      pool: 5

Create a `db/migrate` directory:

    $ mkdir -p db/migrate

Edit your `Gemfile` to specify a specific version of Activerecord.
It is recommeended you do this so that your project is always in a known state:

    gem 'activerecord', '3.2.17', :require => 'active_record'

You will also need to add the appropriate database specific gem to your Gemfile.
For the above example, you would add the following:

    gem 'mysql2'

You should now run `bundle` again so it instals the new gems.

## Usage

Create your database:

    $ bundle exec totem db create

Drop your database:

    $ bundle exec totem db drop

Migrate your database:

    $ bundle exec totem db migrate

Rollback your database (one migration back):

    $ bundle exec totem db rollback

Create a new (empty) migration:

    $ bundle exec totem db migration <name>

Run the 'up' method for a given migration:

    $ bundle exec totem db up <timestamp>

Run the 'down' method for a given migration:

    $ bundle exec totem db down <timestamp>

## Models

You will need to manually create models in the `app` directory.

Example model `app/user.rb` to go with the above migration:

    class User < ActiveRecord::Base
    end

Rember to add the model to the `app/loader.rb` just like you do with all classes in a Totem project:

    require 'user'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

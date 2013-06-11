## pg_faker

Used to simulate PostgreSQL database delays and errors. Works with the 'pg' gem.

Wraps `PG::Connection` for one, more, or all class methods.

Do not use this gem in production or with data, etc. that you cannot restore. Use at your own risk.

### Setup

Either:

    gem install 'pg_faker'

Or, if using Bundler, put this in your Gemfile:

    gem 'pg_faker'

Then run:

    bundle install

### Usage

The following is an example of its use in Rails console with an existing model we'll call MyModel, but this gem is not dependent on Rails or ActiveRecord:

    rails c

Then:

    PG::Connection.fake_delays = true
    PG::Connection.alter_methods
    MyModel.last # => waits 5 seconds for each PG::Connection method call
    PG::Connection.fake_delays = false
    PG::Connection.fake_errors = true
    MyModel.last # => raises error
    PG::Connection.fake_delays = true
    PG::Connection.fake_errors = true
    PG::Connection.fake_delay_seconds = 2
    MyModel.last # => delays 2 seconds and raises error
    PG::Connection.unalter_methods
    MyModel.last => pg behaves normally
    PG::Connection.alter_method :async_exec # => only affect this method
    PG::Connection.start_intermittent_delay_and_error # => sets fake_strategy which is called to randomize settings
    MyModel.last # => may fake delay or raise error
    # this is equivalent
    PG::Connection.fake_strategy = ->(m, *args) do
      PG::Connection.fake_delays = [true, false].sample
      PG::Connection.fake_errors = [true, false].sample
      puts "#{m}(#{args.inspect}) fake_delays=#{PG::Connection.fake_delays} fake_errors=#{PG::Connection.fake_errors}"
    end
    MyModel.last # => may still fake delay or raise error
    PG::Connection.stop_intermittent_delay_and_error # => now it will behave consistently

### License

Copyright (c) 2013 Gary S. Weaver, released under the [MIT license][lic].

[lic]: http://github.com/garysweaver/pg_faker/blob/master/LICENSE

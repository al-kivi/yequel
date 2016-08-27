# Yequel

Provides a Sequel style ORM layer for YAML::Store.
Yequel supports the Sequel syntax with a subset of commands to access YAML::Store tables.  Its target audience is application developers who require light weight alternative to SQL databases.

Yequel provides a small subset of Sequel commands with a goal of allowing for an exchange of the sqlite3 database with YAML::Store.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yequel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yequel

## Usage

Yequel can be used as alternative for Sequel in Ruby frameworks like Sinatra. The Yequel was tested to replace a multi-table implementation that had been built with Sequel and the Sqlite database.

## Development / Testing

This project depends YAML::Store files to act as relational tables. There will be one YAML::Store file for each table. The key requirement is that there is a database sub-directory in your target application environment:

```
$ mkdir /db
``` 

In order to test the gem, refer to the file called '/test/test_helpers.rb' and select a set of commands to test. Here is a sample set of commands:
```
Artist = Yequel::Model.new('test')

Artist.insert(:id=>1, :name=>"YJ")
Artist.insert(:id=>2, :name=>"AS")
Artist.insert(:id=>3, :name=>"AS")

Artist[1]
``` 
The Yequel commands include a subset of the common commands that are used in an Sequel implementation. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/al-kivi/yequel. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


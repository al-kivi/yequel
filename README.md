# Yequel

Provides a sequel style ORM layer for YAML::Store.
Yequel provides a sequel style with basic features to access YAML::Store tables.  Its target audience is application developers who require light weight alternative to SQL databases.

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

TODO: Write usage instructions here

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
 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/yequel. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


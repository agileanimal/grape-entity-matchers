# Grape::Entity::Matchers

[![Build Status](https://travis-ci.org/agileanimal/grape-entity-matchers.png?branch=master)](https://travis-ci.org/agileanimal/grape-entity-matchers)

## Introduction

This gem provides shoulda-style matchers for Rspec to [GrapeEntity](https://github.com/agileanimal/grape-entity).

Currently compatible Rspec 3.

## Using the Matchers

Here are some examples of the matchers in use:

``` ruby
it { is_expected.to represent(:date_of_birth).as(:birthday) }
it { is_expected.to_not represent(:name).as(:birthday) }
it { is_expected.to_not represent(:date_of_birth) }

it { is_expected.to represent(:secret).when( :authorized? => true ) }
it { is_expected.to_not represent(:secret).when( :authorized? => false ) }

it { is_expected.to represent(:super_dooper_secret).as(:top_secret).when( :authorized? => true ) }
it { is_expected.to_not represent(:super_dooper_secret).as(:top_secret).when( :authorized? => false ) }

it { is_expected.to represent(:dog).using(PetEntity) }
it { is_expected.to represent(:cat).as(:kitty).using(PetEntity) }

it { is_expected.to represent(:name).with_documentation(type: String) }

it { is_expected.to document(:name).with(type: String, desc: 'Name of the person') }
it { is_expected.to document(:name).type(String).desc('Name of the person') }
```

## Support for Rspec 2.0.0

Rspec 2.0.0 is no longer supported. For Rspec 2 use version 0.4.0.

## Minitest

It's coming next.

## Installation

Add this line to your application's Gemfile:

    gem 'grape-entity-matchers', :group => :test

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape-entity-matchers

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT License. See LICENSE for details.

## Copyright

Copyright (c) 2014 Mark Madsen, and AGiLE ANiMAL INC.

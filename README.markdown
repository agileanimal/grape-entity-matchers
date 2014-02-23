# Grape::Entity::Matchers

[![Build Status](https://travis-ci.org/agileanimal/grape-entity-matchers.png?branch=master)](https://travis-ci.org/agileanimal/grape-entity-matchers)

## Introduction

This gem provides shoulda-style matchers for Rspec to [GrapeEntity](https://github.com/agileanimal/grape-entity).

Currently compatible with Rspec 2. For Rspec 3 use the rspec3 branch.

## Using the Matchers

Here are some examples of the matchers in use:

``` ruby
it { should represent(:date_of_birth).as(:brithday) }
it { should_not represent(:name).as(:brithday) }
it { should_not represent(:date_of_birth) }
    
it { should represent(:secret).when( :authorized? => true ) }
it { should_not represent(:secret).when( :authorized? => false ) }
    
it { should represent(:super_dooper_secret).as(:top_secret).when( :authorized? => true ) }
it { should_not represent(:super_dooper_secret).as(:top_secret).when( :authorized? => false ) }

it { should represent(:dog).using(PetEntity) }
it { should represent(:cat).as(:kitty).using(PetEntity) }
```

## Support Rspec 3.0.0

Rspec 3.0.0 is in beta 2 at the time of writing this. Support for Rspec will be added on the ```rspec3``` branch.

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

Copyright (c) 2013 Mark Madsen, and AGiLE ANiMAL INC.

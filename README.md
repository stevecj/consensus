# Consensus

The purpose of this gem is to facilitate the construction of Ruby
programs with robust, high-value tests through the creation of
data classes with specific APIs that are used both in production
and as test doubles in tests.

A problem that frequently arises when testing code in a dynamic
language such as Ruby is that there is nothing to ensure that
the APIs of test double objects (mocks and stubs) implemnt the
same APIs as the objects that will be given to the code under test
and that this remains true as the code changes over time.

That situation can be improved through the use of simple struct-
like objects to pass data around, but those objects can be a poor
fit in many cases such as a view model that exposes data that will
not necessarily be consumed and is costly to produce.

## Installation

Add this line to your application's Gemfile:

    gem 'consensus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install consensus

## Usage

Declare a new class that extends Consensus::Portrayal and define
one or more portrayal attributes using the "attribute" class
method.

    class Data < Consensus::Portrayal
      attribute :name, :points, :admin?
    end

Assign simple values or callable objects to attributes of an
instance of the class.

    class UserFetcher
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def user_data
        data = Data.new
        data.name   = name
        data.points = ->{ user_record.points }
        admin       = ->{ user_record.admin? }
        return data
      end

      private

      def user_record
        @user_record ||= User.where(name: name).first
      end
    end

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/consensus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

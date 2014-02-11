# Consensus

Defines a Consensus::Portrayal base class for objects that each
have specific attributes, and each attribute can be backed by either
a simple value or a lazy (callable) object to resolve the value if
and when it is requested. Attribute values are memoized after being
resolved from callables.

## Installation

Add this line to your application's Gemfile:

    gem 'consensus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install consensus

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rendition/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

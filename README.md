# LcDoublet

LC doublet or word ladder implementation using a BFS strategy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lc_doublet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lc_doublet

## Usage

```ruby
require 'lc_doublet'

def main
  dict = "file_dict.txt"
  lc = LcDoublet::Core.new(file)

  s_word = "cat"
  e_word = "dog

  transition = lc_doublet.solve(s_word, e_word)
  if transition.size > 0
    STDOUT.puts " from: #{sword} to #{e_word} - path: #{transition.join(' --> ')}"
  else
    STDOUT.puts " No transition found from: #{sword} to #{e_word}"
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pascal-p/lc_doublet.


## license
BSD-2-Clause
# Tatum
Ruby utility for outputting info to STDOUT, STDERR, a string, or a file.


## Install

The usual:

```
gem install tatum
```

## Use

Everything is done with the TTM module. In the simplest use, use `TTM.puts` to
output any string:

```ruby
TTM.puts 'whatever'
```

By default (and by design) TTM doesn't actually output anything to anywhere.
So without further configuration, the command above wouldn't do anything. That
feature allows you to pepper your code with `TTM.puts` commands without having to
constantly do commands like this:

```ruby
if verbose
  puts 'whatever'
end
```

To set output, use one of the following commands:

```ruby
TTM.io = STDOUT          # output to STDOUT
TTM.io = STDERR          # output to STDERR
TTM.io = './path.txt'    # output to a file
TTM.io = TTM::Cache.new  # output to a stringifiable object
```

You can also set TTM back to not outputting to anything:

```ruby
TTM.io = nil  # don't output to anything
```

See the documentation in tatum.rb for details.

## Author

Mike O'Sullivan
mike@idocs.com

## History

| version  | date         | notes                       |
|----------|--------------|-----------------------------|
| 1.0      | May 18, 2023 | Initial upload.             |
| 1.1      | May 19, 2023 | Minor fix to documentation. |
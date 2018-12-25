# RTesseract

<a href='http://badge.fury.io/rb/rtesseract'>
    <img src="https://badge.fury.io/rb/rtesseract.png" alt="Gem Version" />
</a>
<a href='https://travis-ci.org/dannnylo/rtesseract'>
    <img src="https://travis-ci.org/dannnylo/rtesseract.png?branch=master" alt="Build Status" />
</a>
<a href='https://coveralls.io/r/dannnylo/rtesseract?branch=master'>
    <img src="https://coveralls.io/repos/dannnylo/rtesseract/badge.png?branch=master" alt="Coverage Status" />
</a>
<a href='https://codeclimate.com/github/dannnylo/rtesseract'>
    <img src="https://codeclimate.com/github/dannnylo/rtesseract.png" />
</a>

Ruby library for working with the Tesseract OCR.

## Installation

Check if tesseract ocr programs is installed:

    $ tesseract --version

Add this line to your application's Gemfile:

```ruby
gem 'rtesseract'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rtesseract

## Usage

It's very simple to use rtesseract.

### Convert image to string

```ruby
  image = RTesseract.new("my_image.jpg")
  image.to_s # Getting the value
```

### Convert image to searchable PDF

```ruby
  image = RTesseract.new("my_image.jpg")
  image.to_pdf  # Getting the pdf path
  image.to_s    # Still can get the value only.
  # ...
  # some stuff
  # ...
  image.clean   # to delete file once finished
```

This will preserve the image colors, pictures and structure in the generated pdf.

## Options

### Language

    ```ruby
        RTesseract.new('test.jpg', lang: 'deu')
    ```

    * eng   - English
    * deu   - German
    * deu-f - German fraktur
    * fra   - French
    * ita   - Italian
    * nld   - Dutch
    * por   - Portuguese
    * spa   - Spanish
    * vie   - Vietnamese
    * or any other supported by tesseract.

    Note: Make sure you have installed the language to tesseract

### Other options

  ```ruby
    RTesseract.new('test.jpg', options: :digits)  # Only digit recognition
  ```

  OR

  ```ruby
    RTesseract.new('test.jpg', options: [:digits, :quiet])
  ```

### BOUNDING BOX: TO GET WORDS WITH THEIR POSITIONS
  ```ruby
    RTesseract::Box.new('test_words.png').to_box
  ```

  # => [
  #   {:word => 'If',  :x_start=>52, :y_start=>13, :x_end=>63, :y_end=>27},
  #   {:word => 'you', :x_start=>69, :y_start=>17, :x_end=>100, :y_end=>31},
  #   {:word => 'are', :x_start=>108, :y_start=>17, :x_end=>136, :y_end=>27},
  #   {:word => 'a', :x_start=>143, :y_start=>17, :x_end=>151, :y_end=>27},
  #   {:word => 'friend,', :x_start=>158, :y_start=>13, :x_end=>214, :y_end=>29},
  #   {:word => 'you', :x_start=>51, :y_start=>39, :x_end=>82, :y_end=>53},
  #   {:word => 'speak', :x_start=>90, :y_start=>35, :x_end=>140, :y_end=>53},
  #   {:word => 'the', :x_start=>146, :y_start=>35, :x_end=>174, :y_end=>49},
  #   {:word => 'password,', :x_start=>182, :y_start=>35, :x_end=>267, :y_end=>53},
  #   {:word => 'and', :x_start=>51, :y_start=>57, :x_end=>81, :y_end=>71},
  #   {:word => 'the', :x_start=>89, :y_start=>57, :x_end=>117, :y_end=>71},
  #   {:word => 'doors', :x_start=>124, :y_start=>57, :x_end=>172, :y_end=>71},
  #   {:word => 'will', :x_start=>180, :y_start=>57, :x_end=>208, :y_end=>71},
  #   {:word => 'open.', :x_start=>216, :y_start=>61, :x_end=>263, :y_end=>75}
  # ]


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dannnylo/rtesseract. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rtesseract project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dannnylo/rtesseract/blob/master/CODE_OF_CONDUCT.md).

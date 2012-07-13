# Qualtrics

Use for interaction with Qualtrics

## Installation

Add this line to your application's Gemfile:

    gem 'qualtrics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qualtrics

## Usage


    client = Qualtrics::Client.new host: 'qualtrics.com',
      user: 'test@example.com, token: 'xxx'
    survey = client.get_survey "SV_xxx"
    survey.response_count

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

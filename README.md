# Checkr Canada API Client

[Checkr Canada](https://checkr-canada.api-docs.io/v1/overview) API client.

Built on top of [evil-client](https://github.com/evilmartians/evil-client).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'checkr-canada'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install checkr-canada

## Usage


First, you should initialize a client using your API key:

```ruby
require 'checkr-canada'

client = Checkr::Canada::Client.new('my-checkr-api-key')
```

Then you can make API requests:


```ruby
# ==== Candidates ==== #

# Create a candidate
client.candidates.create(
  first_name: "Test",
  last_name: "Candidate",
  email: "testonboard@test.com",
  phone: "000-000-0002",
  birth_place: "Toronto",
  dob: Date.new(2017, 3, 23), # accepts Data, Time and String objects
  gender: "F"
)

#=> <Checkr::Canada::Entities::Candidate ...>


# Get a candidate
client.candidates.get("123123123")

#=> <Checkr::Canada::Entities::Candidate ...>

# List candidates
result = client.candidates.all(page: 1, per_page: 10)
result.count = 42
result.data #=> [<Checkr::Canada::Entities::Candidate ...>, ...]


# ==== Documents ==== #

# Upload a document
client.documents.upload(candidate_id: "123", url: "https://example.com/image.png", type: "identification")

#=> <Checkr::Canada::Entities::Document ...>


# ==== Addresses ==== #

# Create an address for a candidate
client.addresses.create(
  candidate_id: "123",
  street1: "Mission st",
  street2: "4-2",
  region: "BC",
  city: "San Francisco",
  postal_code: "BC341",
  start_date: "2017-01-02"
)

#=> <Checkr::Canada::Entities::Address ...>


# ==== Reports ==== #

# Create a report
client.reports.create(candidate_id: "123", package: "mvr")

#=> <Checkr::Canada::Entities::Report ...>

# Get a report
client.report.get("123123123")

#=> <Checkr::Canada::Entities::Report ...>

# List reports
result = client.reports.all(page: 1, per_page: 10)
result.count = 42
result.data #=> [<Checkr::Canada::Entities::Report ...>, ...]

# ==== Criminal Records ==== #

# Create a record
client.criminal_records.create(candidate_id: 'ca1b9ca32fc52fd902a57487', offence: 'Killing Teddy Bear', sentence_date: Date.today, location: 'Moscow')

#=> <Checkr::Canada::Entities::CriminalRecord ...>
```

### Exceptions

Client uses `dry-types` and `evil-client` gems to validate params and response format. There can be the following exceptions:

- `Dry::Types::ConstraintError` when provided data is invalid

- `ArgumentError` when required params are missing

- `Evil::Client::Operation::ResponseError` when API-level error occurs (e.g. authentication failure, resource not found, etc)

- `Evil::Client::Operation::UnexpectedResponseError` when we fail to parse response.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/checkr-canada.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


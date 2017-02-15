# Scale API
![Scale API Logo](https://www.scaleapi.com/static/global/facebook-card.png)

This is the official Scale API RubyGem (`scaleapi`).

[Scale](https://www.scaleapi.com) is an API for Human Intelligence. Businesses like Alphabet (Google), Uber, Proctor & Gamble, Houzz, and many more use us to power tasks such as:
- Draw bounding boxes and label parts of images (to train ML algorithms for self-driving cars)
- Place phone calls
- Transcribe documents, images, and webpages
- Scrape websites
- Triage support tickets
- Categorize and compare images, documents, and webpages

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scaleapi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scaleapi

## Usage

First, initialize the Scale API client:

```ruby
require 'scale'

scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')
```

If you're having trouble finding your API Key or Callback Auth Key, then go to the [Scale Dashboard](https://dashboard.scaleapi.com). If you set a default `callback_url` in your account settings, you won't need to pass it in everytime.

## Creating Tasks

### Categoriation Tasks

To create a [categorization task](https://docs.scaleapi.com/#create-categorization-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.create_categorization_task({
  callback_url: 'http://www.example.com/callback', 
  instruction: 'Is this company public or private?', 
  attachment_type: 'website', 
  attachment: 'https://www.google.com', 
  categories: ['public', 'private']
})
```

Upon success, this will return a `Scale::Api::Tasks::Categorization` object. It will raise one of the [errors](#errors) if it's not successful.

Alternatively, you cna also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')
scale.tasks.create({
  type: 'categorization',
  callback_url: 'http://www.example.com/callback', 
  instruction: 'Is this company public or private?', 
  attachment_type: 'website', 
  attachment: 'https://www.google.com', 
  categories: ['public', 'private']
})
```

This will also return a `Scale::Api::Tasks::Categorization` object.

[Read more about creating categorization tasks]((https://docs.scaleapi.com/#create-categorization-task)

### Comparison Tasks

To create a [comparison task](https://docs.scaleapi.com/#create-comparison-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.create_comparison_task({
  callback_url: 'http://www.example.com/callback', 
  instruction: 'Do the objects in these images have the same pattern?', 
  attachments: [
    'http://i.ebayimg.com/00/$T2eC16dHJGwFFZKjy5ZjBRfNyMC4Ig~~_32.JPG',
    'http://images.wisegeek.com/checkered-tablecloth.jpg'
  ],
  choices: ['yes', 'no']
})
```

Upon success, this will return a `Scale::Api::Tasks::Comparison` object. If it fails, it will raise one of the [errors](#errors).

Alternatively, you cna also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.create({
  type: 'comparison',
  callback_url: 'http://www.example.com/callback', 
  instruction: 'Do the objects in these images have the same pattern?', 
  attachments: [
    'http://i.ebayimg.com/00/$T2eC16dHJGwFFZKjy5ZjBRfNyMC4Ig~~_32.JPG',
    'http://images.wisegeek.com/checkered-tablecloth.jpg'
  ],
  choices: ['yes', 'no']
})
```

This will also return a `Scale::Api::Tasks::Comparison` object.

[Read more about creating comparison tasks](https://docs.scaleapi.com/#create-comparison-task)

### Datacollection Tasks

To create a [datacollection task](https://docs.scaleapi.com/#create-datacollection-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.create_comparison_task({
  callback_url: 'http://www.example.com/callback', 
  instruction: 'Find the URL for the hiring page for the company with attached website.'
  attachment: 'https://www.scaleapi.com/',
  fields: {
    hiring_page: 'Hiring Page URL'
  }
})
```

Upon success, this will return a `Scale::Api::Tasks::Datacollection` object. If it fails, it will raise one of the [errors](#errors).

Alternatively, you cna also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.create({
  type: 'datacollection'
  callback_url: 'http://www.example.com/callback', 
  instruction: 'Find the URL for the hiring page for the company with attached website.'
  attachment: 'https://www.scaleapi.com/',
  fields: {
    hiring_page: 'Hiring Page URL'
  }
})
```

This will also return a `Scale::Api::Tasks::Datacollection` object.

[Read more about creating datacollection tasks](https://docs.scaleapi.com/#create-data-collection-task)


### Image Recognition Tasks

To create an [image recognition task](https://docs.scaleapi.com/#create-image-recognition-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.create_annotation_task({
  callback_url: 'http://www.example.com/callback',
  instruction: 'Draw a box around each **baby cow** and **big cow**',
  attachment_type: 'image',
  attachment: 'http://i.imgur.com/v4cBreD.jpg',
  objects_to_annotate: ['baby cow', 'big cow'],
  with_labels: true,
  examples: [
  {
    correct: false,
    image: 'http://i.imgur.com/lj6e98s.jpg',
    explanation: 'The boxes are tight and accurate'
  },
  {
    correct: true,
    image: 'http://i.imgur.com/HIrvIDq.jpg',
    explanation: 'The boxes are neither accurate nor complete'
  }
})
```
Upon success, this will return a `Scale::Api::Tasks::ImageRecognition` object. If it fails, it will raise one of the [errors](#errors).

Note: `create_annotation_task` is also aliased to `create_image_recognition_task`, to help avoid confusion.

Alternatively, you cna also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.create({
  type: 'annotation'
  callback_url: 'http://www.example.com/callback',
  instruction: 'Draw a box around each **baby cow** and **big cow**',
  attachment_type: 'image',
  attachment: 'http://i.imgur.com/v4cBreD.jpg',
  objects_to_annotate: ['baby cow', 'big cow'],
  with_labels: true,
  examples: [
  {
    correct: false,
    image: 'http://i.imgur.com/lj6e98s.jpg',
    explanation: 'The boxes are tight and accurate'
  },
  {
    correct: true,
    image: 'http://i.imgur.com/HIrvIDq.jpg',
    explanation: 'The boxes are neither accurate nor complete'
  }
})
```

This will also return a `Scale::Api::Tasks::ImageRecognition` object.

[Read more about creating image recognition tasks](https://docs.scaleapi.com/#create-image-recognition-task)

### Phone Call Tasks

You can use this to have real people call other people! Isn't that cool?

To create a [phone call task](https://docs.scaleapi.com/#create-phone-call-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.create_phone_call_task({
  callback_url: 'http://www.example.com/callback',
  instruction: 'Call this person and follow the script provided, recording responses',
  phone_number: '5055006865',
  entity_name: 'Alexandr Wang',
  script: 'Hello ! Are you happy today? (pause) One more thing - what is your email address?',
  fields: {
    email: 'Email Address',
  },
  choices: ['He is happy', 'He is not happy']
})
```
Upon success, this will return a `Scale::Api::Tasks::PhoneCall` object. If it fails, it will raise one of the [errors](#errors).

Note: `create_phone_call_task` is also aliased to `create_phonecall_task`, to help avoid confusion.

Alternatively, you cna also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.create({
  type: 'phonecall'
  instruction: 'Call this person and follow the script provided, recording responses',
  phone_number: '5055006865',
  entity_name: 'Alexandr Wang',
  script: 'Hello ! Are you happy today? (pause) One more thing - what is your email address?',
  fields: {
    email: 'Email Address',
  },
  choices: ['He is happy', 'He is not happy']
})
```

This will also return a `Scale::Api::Tasks::PhoneCall` object.

[Read more about creating phone call tasks](https://docs.scaleapi.com/#create-phone-call-task)


### Transcription Tasks

To create a [transcription task](https://docs.scaleapi.com/#create-transcription-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.create_transcription_task({
  callback_url: 'http://www.example.com/callback',
  instruction: 'Transcribe the given fields.',
  attachment_type: 'website',
  attachment: 'http://news.ycombinator.com/',
  fields: {
    title: 'Title of Webpage',
    top_result: 'Title of the top result'
  }
})
```
Upon success, this will return a `Scale::Api::Tasks::Transcription` object. If it fails, it will raise one of the [errors](#errors).

Alternatively, you cna also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.create({
  type: 'transcription'
  callback_url: 'http://www.example.com/callback',
  instruction: 'Transcribe the given fields.',
  attachment_type: 'website',
  attachment: 'http://news.ycombinator.com/',
  fields: {
    title: 'Title of Webpage',
    top_result: 'Title of the top result'
  }
})
```

This will also return a `Scale::Api::Tasks::Transcription` object.

[Read more about creating transcription tasks](https://docs.scaleapi.com/#create-transcription-task)


### Audio Transcription Tasks

To create an [audio transcription task](https://docs.scaleapi.com/#create-audio-transcription-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.create_transcription_task({
  callback_url: 'http://www.example.com/callback',
  attachment_type: 'audio',
  attachment: 'https://storage.googleapis.com/deepmind-media/pixie/knowing-what-to-say/second-list/speaker-3.wav',
  verbatim: false
})
```

Upon success, this will return a `Scale::Api::Tasks::AudioTranscription` object. If it fails, it will raise one of the [errors](#errors).

Alternatively, you cna also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.create({
  type: 'audiotranscription'
  callback_url: 'http://www.example.com/callback',
  attachment_type: 'audio',
  attachment: 'https://storage.googleapis.com/deepmind-media/pixie/knowing-what-to-say/second-list/speaker-3.wav',
  verbatim: false
})
```

This will also return a `Scale::Api::Tasks::AudioTranscription` object.

[Read more about creating audio transcription tasks](https://docs.scaleapi.com/#create-audio-transcription-task)

## Listing Tasks

To get a list of tasks, run the following command:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

task_list = scale.tasks.list
first_task = task_list.first

task_list
```

This will return a `Scale::Api::TaskList` object.

You can filter this list by:
- `start_time` (which expects a `Time` object)
- `end_time` (which expects a `Time` object)
- `type` (which expects one of the [tasks types](##task-object))
- `status` (which expects a string which is either `completed`, `pending`, or `canceled`)

For example:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.list(end_time: Time.parse('January 20th, 2017'), status: 'completed')
```

This will return a `Scale::Api::TaskList` object up to 100 tasks that were completed by January 20th, 2017.


`Scale::Api::TaskList` implements `Enumerable`, meaning you can do fun stuff like this:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

scale.tasks.list.map(&:id)
```

This will return an array containing the last 100 tasks' `task_id`.

By default, `scale.tasks.list` only returns up to 100 tasks, but you can pass in the `limit` yourself.

It also supports pagination, here's an example:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

first_page = scale.tasks.list
second_page = first_page.next_page
```

`Scale::Api::TaskList#next_page` returns the next page in the list of tasks (as a new `Scale::Api::TaskList`). You can see if there are more pages by calling `Scale::Api::TaskList#has_more?` on the object.

For more information, [read our documentation](https://docs.scaleapi.com/#list-all-tasks)

## Finding tasks by ID

To find a task by ID, run the following:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

task_id = 'TASK_ID'
scale.tasks.find(task_id)
```

This will return the appropriate Scaler::Api::Tasks object based on the [task type](#task-types)

## Canceling tasks

There are two ways to cancel a task.

Cancel by `task_id`:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

task_id = 'TASK_ID'
scale.tasks.cancel(task_id)
```

Cancel on the task object:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

task_id = 'TASK_ID'
scale.tasks.find(task_id).cancel!
```

Both ways will return a new [task object](#task-object) for the type, with the `status` set to `canceled` and calling `canceled?` on the task will return true.

## Task Object

All tasks return a task object for their `type`. Currently, this gem supports the following task types:
- `categorization` (`Scale::Api::Tasks::Categorization`)
- `comparison` (`Scale::Api::Tasks::Comparison`)
- `datacollection` (`Scale::Api::Tasks::Datacollection`)
- `annotation` (`Scale::Api::Tasks::ImageRecognition`)
- `phonecall` (`Scale::Api::Tasks::PhoneCall`)
- `transcription` (`Scale::Api::Tasks::Transcription`)
- `audiotranscription` (`Scale::Api::Tasks::AudioTranscription`)

At the time of writing, this is every task type that Scale supports.

## Callbacks

This gem allows you to create and parse callback data, so it can be easily used for web applications:

For example, for Ruby on Rails:

```ruby
# app/controllers/scale_api_controller.rb

require 'scale'

class ScaleApiController < ApplicationController
  # POST /scale_api
  def create
    scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'CALLBACK_AUTH_KEY', callback_url: 'https://example.com/please-change-me')

    callback = scale.build_callback params, callback_key: request.headers['scale-callback-auth']
    callback.response # Response content hash (code and result)
    callback.task     # Scale::Resources::Task object
  end
end
```

## Errors

This gem will raise exceptions on application-level errors. Here are the list of errors:

```ruby
Scale::Api::BadRequest
Scale::Api::TooManyRequests
Scale::Api::NotFound
Scale::Api::Unauthorized
Scale::Api::InternalServerError
Scale::Api::ConnectionError
Scale::Api::APIKeyInvalid
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/scaleapi-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


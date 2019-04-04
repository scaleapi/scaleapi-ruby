# Scale
![Scale Logo](https://scale.ai/static/global/facebook-card.png)

This is the official Scale RubyGem (`scaleapi`).

[Scale](https://scale.ai) is an API for Human Intelligence. Businesses like Alphabet (Google), Uber, Proctor & Gamble, Houzz, and many more use us to power tasks such as:
- Draw bounding boxes and label parts of images (to train ML algorithms for self-driving cars)
- Transcribe documents, images, and webpages
- Scrape websites
- Triage support tickets
- Categorize and compare images, documents, and webpages

Scale is actively hiring software engineers - [apply here](https://scale.ai/about#jobs).

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

First, initialize the Scale client:

```ruby
require 'scale'

scale = Scale.new(api_key: 'SCALE_API_KEY')
```

Note that you can optionally provide a `callback_auth_key` and `callback_url` when initializing the Scale client. You can also set `default_request_params` which is a `Hash` that will be included in every request sent to Scale (either as a query string param or part of the request body).

If you're having trouble finding your API Key or Callback Auth Key, then go to the [Scale Dashboard](https://scale.ai/dashboard). If you set a default `callback_url` in your account settings, you won't need to pass it in everytime.

## Creating Tasks

This gem supports two ways of creating tasks. You can call `create_#{tasktype}_task` on the `scale` object or you can call `scale.tasks.create` and pass in the corresponding `type`. Upon success, it will return the appropriate object for that task type. Upon failure, it will raise an application-level error.

For every type of task, you can pass in the following options when creating:
- `callback_url`: a URL to send the webhook to upon completion. This is required when there is no default callback URL set when either initializing the `Scale` object or in your account settings.
- `urgency`: a string indicating how long the task should take, options are `immediate`, `day`, or `week`. The default is `day`.
- `metadata`: a `Hash` that contains anything you want in it. Use it for storing data relevant to that task, such as an internal ID for your application to associate the task with. Note that the keys of the `Hash` will be returned as `String` rather than `Symbol`.

### Categorization Tasks

To create a [categorization task](https://docs.scale.ai/#create-categorization-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.create_categorization_task({
  callback_url: 'http://www.example.com/callback',
  instruction: 'Is this company public or private?',
  attachment_type: 'website',
  attachment: 'https://www.google.com',
  categories: ['public', 'private']
})
```

Upon success, this will return a `Scale::Api::Tasks::Categorization` object. It will raise one of the [errors](#user-content-errors) if it's not successful.

Alternatively, you can also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

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

[Read more about creating categorization tasks](https://docs.scale.ai/#create-categorization-task)

### Comparison Tasks

To create a [comparison task](https://docs.scale.ai/#create-comparison-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.create_comparison_task({
  callback_url: 'http://www.example.com/callback',
  instruction: 'Do the objects in these images have the same pattern?',
  attachments: [
    'http://i.ebayimg.com/00/$T2eC16dHJGwFFZKjy5ZjBRfNyMC4Ig~~_32.JPG',
    'http://images.wisegeek.com/checkered-tablecloth.jpg'
  ],
  attachment_type: 'image',
  choices: ['yes', 'no']
})
```

Upon success, this will return a `Scale::Api::Tasks::Comparison` object. If it fails, it will raise one of the [errors](#user-content-errors).

Alternatively, you can also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.create({
  type: 'comparison',
  callback_url: 'http://www.example.com/callback',
  instruction: 'Do the objects in these images have the same pattern?',
  attachments: [
    'http://i.ebayimg.com/00/$T2eC16dHJGwFFZKjy5ZjBRfNyMC4Ig~~_32.JPG',
    'http://images.wisegeek.com/checkered-tablecloth.jpg'
  ],
  attachment_type: 'image',
  choices: ['yes', 'no']
})
```

This will also return a `Scale::Api::Tasks::Comparison` object.

[Read more about creating comparison tasks](https://docs.scale.ai/#create-comparison-task)

### Datacollection Tasks

To create a [datacollection task](https://docs.scale.ai/#create-datacollection-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.create_datacollection_task({
  callback_url: 'http://www.example.com/callback',
  instruction: 'Find the URL for the hiring page for the company with attached website.',
  attachment: 'https://scale.ai/',
  attachment_type: 'website',
  fields: {
    hiring_page: 'Hiring Page URL'
  }
})
```

Upon success, this will return a `Scale::Api::Tasks::Datacollection` object. If it fails, it will raise one of the [errors](#user-content-errors).

Alternatively, you can also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.create({
  type: 'datacollection',
  callback_url: 'http://www.example.com/callback',
  instruction: 'Find the URL for the hiring page for the company with attached website.',
  attachment: 'https://scale.ai/',
  attachment_type: 'website',
  fields: {
    hiring_page: 'Hiring Page URL'
  }
})
```

This will also return a `Scale::Api::Tasks::Datacollection` object.

[Read more about creating datacollection tasks](https://docs.scale.ai/#create-data-collection-task)


### Image Recognition Tasks

To create an [image recognition task](https://docs.scale.ai/#create-image-recognition-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.create_annotation_task({
  callback_url: 'http://www.example.com/callback',
  instruction: 'Draw a box around each **baby cow** and **big cow**',
  attachment_type: 'image',
  attachment: 'http://i.imgur.com/v4cBreD.jpg',
  objects_to_annotate: ['baby cow', 'big cow'],
  with_labels: true,
  examples: [
    {
      correct: true,
      image: 'http://i.imgur.com/lj6e98s.jpg',
      explanation: 'The boxes are tight and accurate'
    },
    {
      correct: false,
      image: 'http://i.imgur.com/HIrvIDq.jpg',
      explanation: 'The boxes are neither accurate nor complete'
    }
  ]
})
```
Upon success, this will return a `Scale::Api::Tasks::ImageRecognition` object. If it fails, it will raise one of the [errors](
).

Note: `create_annotation_task` is also aliased to `create_image_recognition_task`, to help avoid confusion.

Alternatively, you can also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.create({
  type: 'annotation',
  callback_url: 'http://www.example.com/callback',
  instruction: 'Draw a box around each **baby cow** and **big cow**',
  attachment_type: 'image',
  attachment: 'http://i.imgur.com/v4cBreD.jpg',
  objects_to_annotate: ['baby cow', 'big cow'],
  with_labels: true,
  examples: [
    {
      correct: true,
      image: 'http://i.imgur.com/lj6e98s.jpg',
      explanation: 'The boxes are tight and accurate'
    },
    {
      correct: false,
      image: 'http://i.imgur.com/HIrvIDq.jpg',
      explanation: 'The boxes are neither accurate nor complete'
    }
  ]
})
```

This will also return a `Scale::Api::Tasks::ImageRecognition` object.

[Read more about creating image recognition tasks](https://docs.scale.ai/#create-image-recognition-task)

### Transcription Tasks

To create a [transcription task](https://docs.scale.ai/#create-transcription-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

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
Upon success, this will return a `Scale::Api::Tasks::Transcription` object. If it fails, it will raise one of the [errors](#user-content-errors).

Alternatively, you can also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.create({
  type: 'transcription',
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

[Read more about creating transcription tasks](https://docs.scale.ai/#create-transcription-task)


### Audio Transcription Tasks

To create an [audio transcription task](https://docs.scale.ai/#create-audio-transcription-task), run the following:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.create_audiotranscription_task({
  callback_url: 'http://www.example.com/callback',
  attachment_type: 'audio',
  attachment: 'https://storage.googleapis.com/deepmind-media/pixie/knowing-what-to-say/second-list/speaker-3.wav',
  verbatim: false
})
```

Upon success, this will return a `Scale::Api::Tasks::AudioTranscription` object. If it fails, it will raise one of the [errors](#user-content-errors).

Alternatively, you can also create a task this way
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.create({
  type: 'audiotranscription',
  callback_url: 'http://www.example.com/callback',
  attachment_type: 'audio',
  attachment: 'https://storage.googleapis.com/deepmind-media/pixie/knowing-what-to-say/second-list/speaker-3.wav',
  verbatim: false
})
```

This will also return a `Scale::Api::Tasks::AudioTranscription` object.

[Read more about creating audio transcription tasks](https://docs.scale.ai/#create-audio-transcription-task)

## Listing Tasks

To get a list of tasks, run the following command:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.list
```

This will return a `Scale::Api::TaskList` object.

`Scale::Api::TaskList` implements `Enumerable`, meaning you can do fun stuff like this:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.list.map(&:id)
```

This will return an array containing the last 100 tasks' `task_id`.

You can also access it like a normal array:
```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.list[0]
```

This will return the appropriate Task object (or nil if empty).

You can filter this list by:
- `start_time` (which expects a `Time` object)
- `end_time` (which expects a `Time` object)
- `type` (which expects one of the [tasks types](#user-content-task-object))
- `status` (which expects a string which is either `completed`, `pending`, or `canceled`)

For example:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

scale.tasks.list(end_time: Time.parse('January 20th, 2017'), status: 'completed')
```

This will return a `Scale::Api::TaskList` object up to 100 tasks that were completed by January 20th, 2017.

By default, `scale.tasks.list` only returns up to 100 tasks, but you can pass in the `limit` yourself.

It also supports pagination, here's an example:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

first_page = scale.tasks.list
second_page = first_page.next_page
```

`Scale::Api::TaskList#next_page` returns the next page in the list of tasks (as a new `Scale::Api::TaskList`). You can see if there are more pages by calling `Scale::Api::TaskList#has_more?` on the object.

`scale.tasks.list` is aliased to `scale.tasks.where` and `scale.tasks.all`.

For more information, [read our documentation](https://docs.scale.ai/#list-all-tasks)

## Finding tasks by ID

To find a task by ID, run the following:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

task_id = 'TASK_ID'
scale.tasks.find(task_id)
```

This will return the appropriate Scaler::Api::Tasks object based on the [task type](#task-types)

## Canceling tasks

There are two ways to cancel a task.

Cancel by `task_id`:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

task_id = 'TASK_ID'
scale.tasks.cancel(task_id)
```

Cancel on the task object:

```ruby
require 'scale'
scale = Scale.new(api_key: 'SCALE_API_KEY')

task_id = 'TASK_ID'
scale.tasks.find(task_id).cancel!
```

Both ways will return a new [task object](#user-content-task-object) for the type, with the `status` set to `canceled` and calling `canceled?` on the task will return true.

## Task Object

All tasks return a task object for their `type`. Currently, this gem supports the following task types:
- `categorization` (`Scale::Api::Tasks::Categorization`)
- `comparison` (`Scale::Api::Tasks::Comparison`)
- `datacollection` (`Scale::Api::Tasks::Datacollection`)
- `annotation` (`Scale::Api::Tasks::ImageRecognition`)
- `transcription` (`Scale::Api::Tasks::Transcription`)
- `audiotranscription` (`Scale::Api::Tasks::AudioTranscription`)

At the time of writing, this is every task type that Scale supports.

### Convenience Methods

Every one of the task type objects has the following convenience (instance) methods:
- `day?`: returns `true` when a task's `urgency` is set to `day`
- `week?`: returns `true` when a task's `urgency` is set to `week`
- `immediate?`: returns `true` when a task's `urgency` is set to `immediate`
- `pending?`: returns `true` when a task's `status` is set to `pending`
- `completed?`: returns `true` when a task's `status` is set to `completed`
- `canceled?`: returns `true` when a task's `status` is set to `canceled`
- `callback_succeeded?`: returns `true` when the response from the callback was successful

You can also access all the properties of the task object directly, some examples:
```ruby
irb(main):009:0> task.instruction
=> "Find the URL for the hiring page for the company with attached website."
```

```ruby
irb(main):013:0> task.metadata
=> {"bagel"=>true}
```

```ruby
irb(main):016:0> task.completed_at
=> 2017-02-10 20:41:12 UTC
```

## Callbacks

This gem allows you to create and parse callback data, so it can be easily used for web applications:

For example, for Ruby on Rails:

```ruby
# app/controllers/scale_api_controller.rb

require 'scale'

class ScaleApiController < ApplicationController
  # POST /scale_api
  def create
    scale = Scale.new(api_key: 'SCALE_API_KEY', callback_auth_key: 'SCALE_CALLBACK_AUTH_KEY')

    callback = scale.build_callback params, callback_key: request.headers['scale-callback-auth']
    return render status: 403 unless callback.verified? # Render forbidden if verifying the callback fails

    callback.response # Response content hash (code and result)
    callback.task     # Scale::Api::Tasks object for task type

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

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `scaleapi-ruby.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To test locally, run `bundle exec rspec`. By default, client - server communication is mocked by [vcr](https://github.com/vcr/vcr), which uses local [casettes](spec/cassettes) recorded from production server.
To test against production server, set a test api key as `SCALE_TEST_API_KEY` and run `bundle exec rake spec:production`, which sets environment variable `SCALE_TEST_SERVER` to `production`. It will also update new client - server communication in the cassette.
Please note that changes in the cassettes will break existing specs. This is because 1) the server may return random results for test api key, and 2) some of the cassettes have been modified specifically for the specs.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scaleapi/scaleapi-ruby.


Thanks to [wikiti](https://github.com/wikiti/) for creating the first unofficial Scale API Ruby Client!


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

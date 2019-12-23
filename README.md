# Slowpoke

[Rack::Timeout](https://github.com/heroku/rack-timeout) enhancements for Rails

- safer service timeouts
- dynamic timeouts
- custom error pages

## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'slowpoke'
```

And run:

```sh
rails generate slowpoke:install
```

This creates a `public/503.html` you can customize.

## Development

To try out custom error pages in development, temporarily add to `config/environments/development.rb`:

```ruby
config.slowpoke.timeout = 1
config.consider_all_requests_local = false
```

And add a `sleep` call to one of your actions:

```ruby
sleep(2)
```

The custom error page should appear.

## Production

The default timeout is 15 seconds. You can change this in `config/environments/production.rb` with:

```ruby
config.slowpoke.timeout = 5
```

For dynamic timeouts, use:

```ruby
config.slowpoke.timeout = lambda do |env|
  request = Rack::Request.new(env)
  request.path.start_with?("/admin") ? 15 : 5
end
```

Subscribe to timeouts with:

```ruby
ActiveSupport::Notifications.subscribe "timeout.slowpoke" do |name, start, finish, id, payload|
  # report timeout
end
```

To learn more, see the [Rack::Timeout documentation](https://github.com/heroku/rack-timeout).

## Safer Service Timeouts

Rack::Timeout can raise an exception at any point in the code, which can leave your app in an [unclean state](https://www.schneems.com/2017/02/21/the-oldest-bug-in-ruby-why-racktimeout-might-hose-your-server/). The safest way to recover from a request timeout is to spawn a new process. This is the default behavior for Slowpoke.

For threaded servers like Puma, this means killing all threads when any one of them times out. This can have a significant impact on performance.

You can customize this behavior with:

```ruby
Slowpoke.on_timeout do |env|
  next if Rails.env.development? || Rails.env.test?

  exception = env["action_dispatch.exception"]
  if exception && exception.backtrace.first.include?("/active_record/")
    Slowpoke.kill
  end
end
```

Note: To access `env["action_dispatch.exception"]` in development, temporarily add to `config/environments/development.rb`:

```ruby
config.consider_all_requests_local = false
```

## Database Timeouts

It’s a good idea to set a [statement timeout](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts/#statement-timeouts-1) and a [connect timeout](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts/#activerecord). For Postgres, your `config/database.yml` should include something like:

```yml
production:
  connect_timeout: 3 # sec
  variables:
    statement_timeout: 5s
```

## Upgrading

### 0.3.0

If you set the timeout with:

```ruby
Slowpoke.timeout = 5
```

Remove it and add to `config/environments/production.rb`:

```ruby
config.slowpoke.timeout = 5
```

If you use migration timeouts, check out [this guide](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts/#statement-timeouts-1) for how to configure them directly in `config/database.yml`.

### 0.1.0

`0.1.0` removes database timeouts, since Rails supports them by default. To restore the previous behavior, use:

```yaml
production:
  variables:
    statement_timeout: <%= Slowpoke.timeout * 1000 %>
```

## History

View the [changelog](https://github.com/ankane/slowpoke/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/slowpoke/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/slowpoke/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/ankane/slowpoke.git
cd slowpoke
bundle install
```

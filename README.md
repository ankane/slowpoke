# Slowpoke

[Rack::Timeout](https://github.com/heroku/rack-timeout) enhancements for Rails

- custom error pages
- [safer service timeouts](https://github.com/heroku/rack-timeout/issues/39)

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

## How to Use

The default timeout is 15 seconds. Change this in `config/environments/production.rb` with:

```ruby
Slowpoke.timeout = 5
```

Test by adding a `sleep` call to one of your actions:

```ruby
sleep(20)
```

**Note:** Your custom error page will only show up in non-development environments. Development shows exception details.

Subscribe to timeouts with:

```ruby
ActiveSupport::Notifications.subscribe "timeout.slowpoke" do |name, start, finish, id, payload|
  # report timeout
end
```

To learn more, see the [Rack::Timeout documentation](https://github.com/heroku/rack-timeout).

## Threaded Servers

The only safe way to recover from a request timeout is to spawn a new process. For threaded servers like Puma, this means killing all threads when any one of them times out. This can have a significant impact on performance.

## Database Timeouts

It’s a good idea to set a [statement timeout](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts/#statement-timeouts-1) and a [connect timeout](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts/#activerecord).

## Upgrading

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

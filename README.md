# Slowpoke

[Rack::Timeout](https://github.com/heroku/rack-timeout) is great. Slowpoke makes it better with:

- custom error pages
- [safer service timeouts](https://github.com/heroku/rack-timeout/issues/39)
- wait timeouts that don’t kill your web server

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

The default timeout is 15 seconds. Change this with:

```ruby
Slowpoke.timeout = 10
```

or set:

```ruby
ENV["REQUEST_TIMEOUT"]
```

Subscribe to timeouts with:

```ruby
ActiveSupport::Notifications.subscribe "timeout.slowpoke" do |name, start, finish, id, payload|
  # report timeout
end
```

To learn more, see the [Rack::Timeout documentation](https://github.com/heroku/rack-timeout#the-rabbit-hole).

## Database Timeouts

For PostgreSQL, set a statement timeout in `config/database.yml`:

```yaml
production:
  variables:
    statement_timeout: 30000 # ms
```

## Upgrading

`0.1.0` removes database timeouts, since Rails supports them by default.

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/slowpoke/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/slowpoke/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

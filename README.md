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
    statement_timeout: 250 # ms
```

To use a different timeout for migrations, set: [master]

```ruby
ENV["MIGRATION_STATEMENT_TIMEOUT"] = 60000 # ms
```

Test timeouts with the [pg_sleep](http://www.postgresql.org/docs/9.0/static/functions-datetime.html#FUNCTIONS-DATETIME-DELAY) function.

```sql
SELECT pg_sleep(20);
```

## Upgrading

`0.1.0` removes database timeouts, since Rails supports them by default.  To restore the previous behavior, use:

```yaml
production:
  variables:
    statement_timeout: <%= Slowpoke.timeout * 1000 %>
```

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/slowpoke/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/slowpoke/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

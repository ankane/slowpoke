# Slowpoke

[Rack::Timeout](https://github.com/heroku/rack-timeout) enhancements for Rails

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

Test by adding a `sleep` call to one of your actions:

```ruby
sleep(20)
```

Subscribe to timeouts with:

```ruby
ActiveSupport::Notifications.subscribe "timeout.slowpoke" do |name, start, finish, id, payload|
  # report timeout
end
```

To learn more, see the [Rack::Timeout documentation](https://github.com/heroku/rack-timeout#the-rabbit-hole).

## Threaded Servers

The only safe way to recover from a request timeout is to spawn a new process. For threaded servers like Puma, this means killing all threads when any one of them times out. This can have a significant impact on performance.

## Database Timeouts

For PostgreSQL, set connect and statement timeouts in `config/database.yml`:

```yaml
production:
  connect_timeout: 1 # sec
  variables:
    statement_timeout: 250 # ms
```

To use a different statement timeout for migrations, set:

```ruby
ENV["MIGRATION_STATEMENT_TIMEOUT"] = 60000 # ms
```

Test connect timeouts by setting your database host to an [unroutable IP](https://stackoverflow.com/questions/100841/artificially-create-a-connection-timeout-error).

```yaml
development:
  host: 10.255.255.1
```

Test statement timeouts with the [pg_sleep](https://www.postgresql.org/docs/current/static/functions-datetime.html#FUNCTIONS-DATETIME-DELAY) function.

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

## History

View the [changelog](https://github.com/ankane/slowpoke/blob/master/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/slowpoke/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/slowpoke/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

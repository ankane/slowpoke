# Slowpoke

Timeouts made easy

- custom error page
- database timeouts
- notifications

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

The default timeout is 15 seconds. Change this with:

```ruby
ENV["REQUEST_TIMEOUT"] = 10
```

Subscribe to timeouts

```ruby
ActiveSupport::Notifications.subscribe "timeout.slowpoke" do |name, start, finish, id, payload|
  # report timeout
end
```

### Database Timeouts

For ActiveRecord (PostgreSQL only), change the database timeout with:

```ruby
ENV["DATABASE_TIMEOUT"] = 10
```

Defaults to the request timeout.

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/slowpoke/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/slowpoke/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

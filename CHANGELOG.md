## 0.3.2 (2019-12-23)

- Added `on_timeout` method

## 0.3.1 (2019-12-10)

- Added support for dynamic timeouts

## 0.3.0 (2019-05-31)

- Use proper signal for Puma
- Dropped support for rack-timeout < 0.4
- Dropped support for migration timeouts
- Dropped support for Rails < 5

## 0.2.1 (2018-05-21)

- Don’t kill server in test environment
- Require rack-timeout < 0.5

## 0.2.0 (2017-11-05)

- Fixed custom error pages for Rails 5.1
- Fixed migration statement timeout
- Don’t kill server in development

## 0.1.3 (2016-08-03)

- Fixed deprecation warning in Rails 5
- No longer requires ActiveRecord

## 0.1.2 (2016-02-10)

- Updated to latest version of rack-timeout, removing the need to bubble timeouts

## 0.1.1 (2015-08-02)

- Fixed safer service timeouts
- Added migration statement timeout

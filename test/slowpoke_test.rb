require_relative "test_helper"

class SlowpokeTest < ActionDispatch::IntegrationTest
  def test_timeout
    get timeout_url
    assert_response :service_unavailable
    assert_match "This page took too long to load", response.body
  end

  def test_dynamic
    get admin_url
    assert_response :success
  end

  def test_on_timeout
    timed_out = false
    previous_value = Slowpoke.on_timeout
    begin
      Slowpoke.on_timeout { timed_out = true }
      get timeout_url
    ensure
      Slowpoke.on_timeout(&previous_value)
    end
    assert timed_out
  end

  def test_notifications
    notifications = []
    callback = ->(*args) { notifications << args }
    ActiveSupport::Notifications.subscribed(callback, "timeout.slowpoke") do
      get timeout_url
    end
    assert_equal 1, notifications.size
  end
end

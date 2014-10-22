module Slowpoke
  module Controller
    extend ActiveSupport::Concern

    included do
      around_filter :bubble_timeout
    end

    private

    def bubble_timeout
      yield
    rescue => exception
      if exception.respond_to?(:original_exception) and exception.original_exception.is_a?(Rack::Timeout::Error)
        raise exception.original_exception
      else
        raise exception
      end
    end

  end
end

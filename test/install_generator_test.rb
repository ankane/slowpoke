require_relative "test_helper"

require "generators/slowpoke/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Slowpoke::Generators::InstallGenerator
  destination File.expand_path("../tmp", __dir__)

  def test_works
    run_generator
    assert_file "public/503.html"
  end
end

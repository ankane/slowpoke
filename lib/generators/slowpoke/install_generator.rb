require "rails/generators"

module Slowpoke
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_503_html
        template "503.html", "public/503.html"
      end

    end
  end
end

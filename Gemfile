source "https://rubygems.org"
# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec Jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll", "~> 4.4.1"
gem "liquid", "~> 4.0.4"
gem "activesupport", "~> 7.0.7.1"
# This is the default theme for new Jekyll sites. You may change this to anything you like.
#gem "minima", "~> 2.5"

#gem "jekyll-remote-theme", '~>0.4.3'
#gem 'i18n', '~> 1.8.11'
#gem "webrick", "~> 1.7"
#gem "nokogiri", "~> 1.16.5"
#gem "rexml", ">= 3.3.3"
# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem "github-pages", group: :jekyll_plugins
# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.16.0"
  gem "jekyll-seo-tag","~>2.8.0"
  gem 'jekyll-sitemap', '~> 1.4'
  gem 'kramdown-parser-gfm', '~> 1.1'
  gem 'jemoji', '~> 0.13.0'
  gem 'jekyll-timeago'
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]


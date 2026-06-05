source "https://rubygems.org"

# Keep Jekyll aligned with GitHub Pages' supported runtime and plugin whitelist.
gem "github-pages", "232", group: :jekyll_plugins

# Whitelisted plugins.
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.17"
end

# Dev/CI tooling. Mirrors `make ci-*` targets — keep in sync.
group :development, :test do
  gem "html-proofer", "~> 5.0"
  gem "bundler-audit", "~> 0.9"
end

# Windows / JRuby tzdata
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "wdm", "~> 0.1.0" if Gem.win_platform?

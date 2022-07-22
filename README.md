# Scan

- Install ruby version 3.0.4 (I recommend use [rvm](https://rvm.io/:rvm))
- rvm install ruby-3.0.4
- gem install bundler
- git clone git@github.com:adilsonchacon/rscan.git
- cd rscan
- bundle install
- ruby main.rb --help
## Full example

ruby main.rb --path=spec/fixtures --output=json -sqli -expo -xss
## Tests

- rspec

# Scan

## Observation

- Only files _.html_ and _.js_ can be scanned by XSS
- HTML files are scanned only between _script_ tags and events based on this [w3c](https://www.w3schools.com/tags/ref_eventattributes.asp) document, example:

```javascript
<html>
  <script type="text/javascript">
    alert(1);
  </script>

  <body onload="alert(2)" class='test'>
    <h1 id="1">Test XSS</h1>
    <h4>H4 no attributes</h4>
  </body>
</html>
```

## Install

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

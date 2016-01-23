# Booster Shot

This is a base rails application starting point. There are always a base set
of gems and other things I install when starting a new project. This helps
me cut down on the repetition.

## Getting started

* `.ruby-version` is set to `2.3.0`
* `.rbenv-gemsets` is set to `.gems`

```console
$ git clone https://github.com/DustinFisher/booster-shot
$ cd booster-shot
$ bundle install
$ rake db:migrate
$ rails s
```

## What's Included
* [Devise](https://github.com/plataformatec/devise) for user authentication
* [Puma](https://github.com/puma/puma) for the webserver
* [RSpec](https://github.com/rspec/rspec) for testing
* [RSpec-Given](https://github.com/rspec-given/rspec-given) for Given-When-Then testing syntax
* [Twitter-Bootstrap-Rails](https://github.com/seyhunak/twitter-bootstrap-rails) for styles
* Bootstrap style applied to flash messagesjk
* Static pages controller
* Turbolinks are removed

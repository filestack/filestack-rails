# Contributing

We love pull requests. Here's a quick guide:

1. Fork the repo.

2. Create your feature branch (`git checkout -b my-new-feature`)

3. Install Gems `bundle`

4. Create and migrate the test database `bundle exec rake db:create db:migrate RAILS_ENV=test`

5. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle exec rake`

6. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

7. Make the test pass.

8. Update [CHANGELOG.md](https://github.com/Ink/filepicker-rails/blob/master/CHANGELOG.md) with a brief description of your changes under the `unreleased` heading.

9. Commit your changes (`git commit -am 'Added some feature'`)

10. Push to the branch (`git push origin my-new-feature`)

11. Create new Pull Request

At this point you're waiting on us. We like to at least give you feedback, if not just
accept it, within a few days, depending on our internal priorities.

Some things that will increase the chance that your pull request is accepted is to follow the practices described on [Ruby style guide](https://github.com/bbatsov/ruby-style-guide), [Rails style guide](https://github.com/bbatsov/rails-style-guide) and [Better Specs](http://betterspecs.org/).


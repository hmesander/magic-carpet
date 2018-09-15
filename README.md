# Magic Carpet (Rails JSON API)

This repo contains the backend Rails API of the Magic Carpet app. It serves json intended to be consumed by the [Magic Carpet Mobile App](https://github.com/jude-lawson/magic-carpet-mobile).

<hr>

## Installation & Setup
1. Clone down the repo:

  ```shell
  git clone git@github.com:hmesander/magic-carpet.git
  ```

2. Install necessary dependencies:

  ```shell
  bundle install
  ```

3. Set up the database

  ```shell
  rake db:setup
  ```

4. Run test suite

  ```shell
    rspec
  ```

  Note:  Some tests will fail because you need environmental variables (yelp and lyft api keys) that cannot be published on GitHub for obvious security reasons.

<hr>

## Running the Server Locally

To see your code in action locally, you need to fire up a development server. Use the command:

  ```shell
  rails s
  ```

Once the server is running, visit API endpoints in your browser:

* `http://localhost:3000/` to run your application.

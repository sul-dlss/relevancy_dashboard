[![Build Status](https://travis-ci.org/sul-dlss/relevancy_dashboard.svg?branch=master)](https://travis-ci.org/sul-dlss/relevancy_dashboard)
[![Coverage Status](https://coveralls.io/repos/github/sul-dlss/relevancy_dashboard/badge.svg?branch=master)](https://coveralls.io/github/sul-dlss/relevancy_dashboard?branch=master)
[![Code Climate](https://codeclimate.com/github/sul-dlss/relevancy_dashboard/badges/gpa.svg)](https://codeclimate.com/github/sul-dlss/relevancy_dashboard)
[![Code Climate Test Coverage](https://codeclimate.com/github/sul-dlss/relevancy_dashboard/badges/coverage.svg)](https://codeclimate.com/github/sul-dlss/relevancy_dashboard/coverage)
[![GitHub version](https://badge.fury.io/gh/sul-dlss%2Frelevancy_dashboard.svg)](https://badge.fury.io/gh/sul-dlss%2Frelevancy_dashboard)

# Relevancy Dashboard

The relevancy dashboard provides a way to visualize document ranking and relevancy differences across different solr configurations.

## Requirements

1. Ruby 3.1
2. [bundler](http://bundler.io/) gem
3. [Redis](https://redis.io/)

## Installation

Clone the repository

    $ git clone git@github.com:sul-dlss/relevancy_dashboard.git

Move into the app, install dependencies, and initialize the database

    $ cd relevancy_dashboard
    $ bundle install
    $ yarn install
    $ rails db:migrate

Start the development server

    $ bin/dev

## Configuring

Configuration is handled through the application.

## Testing

The test suite (with RuboCop style enforcement) will be run with the default rake task (also run on travis)

    $ bin/rake

The specs can be run without RuboCop style enforcement

    $ bundle exec rspec

The RuboCop style enforcement can be run without running the tests

    $ bundle exec rubocop

## Adding endpoints and searches

Endpoints can be added from the application (`/endpoints/new`). It should point at
the query endpoint (often `/select`) for a solr core/collection. It is recommended to add at least two endpoints.

Then, different search cases can be added. The query parameters are raw URL parameters (of the form `q=xyz&sort=score+asc`).

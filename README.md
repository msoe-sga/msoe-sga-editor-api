[![Build Status](https://travis-ci.org/msoe-sg/msoe-sg-editor-api.svg?branch=master)](https://travis-ci.org/msoe-sg/msoe-sg-editor-api)
## Setup
1. Follow the instructions from the wiki article [here](https://github.com/msoe-sg/msoe-sg-website/wiki/Environment-Setup) to setup your development environment.
2. Open up a terminal to the folder where you want to clone the repo and run the command `git@github.com:msoe-sg/msoe-sg-editor-api.git`
3. After run the clone change into the project directory by running the command `cd msoe-sg-editor-api`
4. Next install the dependencies for the site by running the command `bundle install`
5. Get the Airtable API key from the webmaster and run the command `export AIRTABLE_API_KEY="<Insert Key Here>"`
6. Get the GitHub API token from the webmaster and run the command `export GITHUB_ACCESS_TOKEN="<Insert Token Here>"`
7. If the bundle install command succeeds you should be able to run the api locally by running the command `rails server`. This should put forth some output, and you can now make requests to the api on port 3000
8. Contribute
Our git flow process is typical--we have a master branch that gets released to the public, a dev branch for merging ongoing development, and feature branches for individual tasks.
If you have questions on how to contribute, please contact admin@msoe-sse.com or msoe.sg.hosting@gmail.com and we will get back to you at our earliest convenience.

## Continuous Integration
There are checks that will be performed whenever Pull Requests are opened.  To save time on the build server, please run the tests locally to check for errors that will occur in the CI builds.

1. To run [Rubocop](https://github.com/ashmaroli/rubocop-jekyll), run the command `bundle exec rubocop`

## Developing on a development version of the jekyll-github-pages-gem
If you need to test changes made to the jekyll-github-pages-gem repo. Follow the below instructions for specifying the Gemfile to pull from a development version of the gem.

1. First open up the Gemfile and comment out the line `gem jekyll-github-pages-gem` which specifies to use the gem from rubygems
2. Then add the following line to specify the use the gem from a GitHub branch `gem 'jekyll-github-pages-gem', github: 'msoe-sg/jekyll-github-pages-gem', branch: '<BRANCH_HERE>'`
3. Delete the Gemfile.lock and rerun the `bundle install` command
4. Once you finish developing before creating a Pull Request restore the Gemfile to how it was previously, and repeat step 3.

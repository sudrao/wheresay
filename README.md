WhereSay
========

Rails app to see 50 tweets near a given Longitude/ Lattitude.

Test
----
rake spec

Setup
-----

Rename config/credentials_blank.yml to config/credentials.yml and fill in with oauth credentials

rake make_capped # makes a capped mongo db collection

rake pull_tweets # runs continuously to pull in and save tweets in mongo db

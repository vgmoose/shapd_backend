 alias set_gemfile='export BUNDLE_GEMFILE="`pwd`/Gemfile"'
 bundle check || bundle install
 bundle exec rake test_app
 cd api; set_gemfile; bundle install; bundle exec rspec spec
 cd ../backend; set_gemfile; bundle install; bundle exec rspec spec
 cd ../core; set_gemfile; bundle install; bundle exec rspec spec
 cd ../frontend; set_gemfile; bundle install; bundle exec rspec spec

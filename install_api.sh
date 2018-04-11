rake db:create
rake db:migrate
rake db:seed
rake test

rm -f /myapp/tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'
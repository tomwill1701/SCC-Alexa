
rake routes
rake -I db
rake db:create
rake db:drop
rake db:migrate
rake db:seed
rake db:roll
rake db:setup
rake db:reset

annotate

git status
git add .
git commit -m "xxx"
git push origin master
git push origin auto-rake-task
git push heroku master
git remote -v

bundle install
gem list

binding.pry
rails c
rails s


active job:

rake jobs:clear
rake jobs:workout
rake jobs:work

Procfile:
worker: rake jobs:work

heroku ps:scale worker=1


Heroku

rake assets:precompile
heroku pg:reset DATABASE
heroku run rake db:migrate
heroku run rake db:seed
heroku run rails c
heroku logs -n 500
heroku config:set name=fred
heroku help config


reveal-md demo

kill -9 $(lsof -i tcp:3000 -t)

xx


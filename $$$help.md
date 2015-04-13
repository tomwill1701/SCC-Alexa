
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


reveal-md demo

kill -9 $(lsof -i tcp:3000 -t)

xx


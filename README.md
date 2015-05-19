<h1> Scribe API </h1>
Scribe is a framework for crowdsourcing the transcription of text-based documents, particularly documents that are not well suited for Optical Character Recognition.

Check out the <a href="http://docs.scribeapi1.apiary.io/#reference">documentation</a> and the <a href="https://github.com/zooniverse/ScribeAPI/wiki">wiki</a> for further resources.

<h1>Quick Start</h1>
Copy example project folder:
`cp -R project/example_project project/%PROJECT_KEY%`

Edit your project files - in particular:
 * Project properties (project.rb)
 * Workflows (workflows/*.json )
 * Groups and subjects (subjects/groups.csv, each 'name' of which refers to subjects/group_%NAME%.csv)
 * Pages (content/*.html.erb)

Build project:
`rake project_load[%PROJECT_KEY%]`

<h1>Deploying To Heroku</h1>

```
$ heroku git:remote -a HEROKU_APP_NAME
$ git add .
$ git commit -am "make it better"
$ git push heroku master
$ heroku run rake --trace project_load[%PROJECT_KEY%]
```

<h1>Background</h1>

This application was generated with the rails_apps_composer gem:
https://github.com/RailsApps/rails_apps_composer
provided by the RailsApps Project:
http://railsapps.github.io/

Recipes:
["apps4", "controllers", "core", "email", "extras", "frontend", "gems", "git", "init", "models", "prelaunch", "railsapps", "readme", "routes", "saas", "setup", "testing", "views"]

Preferences:
{:git=>true, :apps4=>"none", :dev_webserver=>"webrick", :prod_webserver=>"same", :database=>"mongodb", :orm=>"mongoid", :templates=>"erb", :unit_test=>"rspec", :integration=>"cucumber", :continuous_testing=>"none", :fixtures=>"none", :frontend=>"none", :email=>"gmail", :authentication=>"devise", :devise_modules=>"default", :authorization=>"none", :form_builder=>"none", :starter_app=>"users_app", :rvmrc=>false, :quiet_assets=>true, :better_errors=>true}

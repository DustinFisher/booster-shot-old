copy_file   "app/assets/stylesheets/bootstrap_and_overrides.scss"
copy_file   "app/assets/stylesheets/application.css.scss"
remove_file "app/assets/stylesheets/application.css"

copy_file   "app/assets/javascripts/application.js", :force => true
copy_file   "app/assets/javascripts/bootstrap.js.coffee", :force => true
copy_file   "app/controllers/static_pages_controller.rb"
copy_file   "app/helpers/application_helper.rb", :force => true
remove_file "app/views/layouts/application.html.erb"
copy_file   "app/views/layouts/application.slim", :force => true
copy_file   "app/views/shared/_flash.slim"
copy_file   "app/views/static_pages/index.slim"

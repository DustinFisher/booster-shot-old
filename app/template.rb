copy_file "app/assets/stylesheets/bootstrap_and_overrides.css.scss"
copy_file "app/assets/stylesheets/application.css.scss"
remove_file "app/assets/stylesheets/application.css"

copy_file "app/controllers/static_pages_controller.rb"
copy_file "app/helpers/application_helper.rb"
copy_file "app/views/layouts/application.html.erb", :force => true
copy_file "app/views/shared/_flash.html.erb"
copy_file "app/views/static_pages/index.html.erb"
template "config/database.example.yml.tt"
remove_file "config/database.yml"
remove_file "config/secrets.yml"

insert_into_file "config/routes.rb",
                 :after => /Rails\.application.*\n/ do
  '  root "static_pages#index"'
end

copy_file "config/initializers/secret_token.rb"

apply "config/environments/development.rb"

copy_file "config/environments/test.rb", :force => true

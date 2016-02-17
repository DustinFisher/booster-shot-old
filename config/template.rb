template "config/database.example.yml.tt"
remove_file "config/database.yml"
remove_file "config/secrets.yml"

gsub_file "config/routes.rb", /  # root 'welcome#index'/ do
  '  root "static_pages#index"'
end

copy_file "config/initializers/secret_token.rb"

apply "config/environments/development.rb"

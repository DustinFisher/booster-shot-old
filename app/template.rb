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
copy_file   "app/views/devise/registrations/edit.slim"
copy_file   "app/views/devise/registrations/new.slim"
copy_file   "app/views/devise/sessions/new.slim"
copy_file   "app/views/devise/unlocks/new.slim"
copy_file   "app/views/devise/passwords/new.slim"
copy_file   "app/views/devise/passwords/edit.slim"
copy_file   "app/views/devise/shared/_links.slim"

#modal
copy_file   "app/views/layouts/modal.html.slim"
copy_file   "app/services/modal_responder.rb"
copy_file   "app/assets/javascripts/modals.coffee"

insert_into_file "app/controllers/application_controller.rb",
                 :after => /class ApplicationController.*\n/ do
  "  include Pundit\n"
end

insert_into_file "app/controllers/application_controller.rb",
                 :after => /protect_from_forgery.*\n/ do
  "
  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end\n
  "
end

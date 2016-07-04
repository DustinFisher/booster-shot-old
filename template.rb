RAILS_REQUIREMENT = "~> 5.0.0"

def go_go_template!
  assert_rails_version
  assert_postgresql
  add_template_repository_to_source_path

  template "Gemfile.tt", :force => true

  remove_file "README.rdoc"

  template "example.env.tt"
  template "ruby-version.tt", ".ruby-version", :force => true
  copy_file "rbenv-gemsets", ".rbenv-gemsets", :force => true
  copy_file "gitignore", ".gitignore", :force => true
  copy_file "rubocop.yml", ".rubocop.yml", :force => true

  apply "app/template.rb"
  apply "bin/template.rb"
  apply "config/template.rb"
  apply "lib/template.rb"

  git :init unless preexisting_git_repo?
  empty_directory ".git/safe"

  run_with_clean_bundler_env "bin/setup"
  apply "spec/template.rb"
  add_basic_roles
  run_with_clean_bundler_env "rails generate simple_form:install --bootstrap"
  generate_spring_binstubs

  binstubs = %w(
    brakeman bundler-audit
  )
  run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')}"


  unless preexisting_git_repo?
    git :add => "-A ."
    git :commit => "-n -m 'Intializing a new project'"
    setup_react if add_react?
    git :checkout => "-b development"
  end
end

def setup_react
  run "spring stop"
  run "rails generate react_on_rails:install"
  run "bundle && npm install"
  run "gem install foreman"
  git :add => "-A ."
  git :commit => "-n -m 'Adding react on rails'"
end

def assert_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

def assert_postgresql
  return if IO.read("Gemfile") =~ /^\s*gem ['"]pg['"]/
  fail Rails::Generators::Error,
       "This template requires PostgreSQL, "\
       "but the pg gem isn’t present in your Gemfile."
end

require "fileutils"
require "shellwords"

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    source_paths.unshift(tempdir = Dir.mktmpdir("booster-shot-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git :clone => [
      "--quiet",
      "https://github.com/dustinfisher/booster-shot.git",
      tempdir
    ].map(&:shellescape).join(" ")
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def run_with_clean_bundler_env(cmd)
  return run(cmd) unless defined?(Bundler)
  Bundler.with_clean_env { run(cmd) }
end

def preexisting_git_repo?
  @preexisting_git_repo ||= (File.exist?(".git") || :nope)
  @preexisting_git_repo == true
end

def gemfile_requirement(name)
  @original_gemfile ||= IO.read("Gemfile")
  req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,[><~= \t\d\.\w'"]*).*$/, 1]
  req && req.gsub("'", %(")).strip.sub(/^,\s*"/, ', "')
end

def add_basic_roles
  insert_into_file "app/models/user.rb",
                   :after => /class User.*\n/ do
"
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end\n
"
  end
end

def ask_with_default(question, color, default)
  return default unless $stdin.tty?
  question = (question.split("?") << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

def add_react?
  return @add_react if defined?(@add_react)
  @add_react = \
    ask_with_default("Use React on Rails?", :blue, "no") =~ /^y(es)?/i
end

go_go_template!

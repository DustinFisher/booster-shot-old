RAILS_REQUIREMENT = "~> 4.2.0"

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

  git :init unless preexisting_git_repo?
  empty_directory ".git/safe"

  run_with_clean_bundler_env "bin/setup"
  apply "spec/template.rb"
  run_with_clean_bundler_env "rails generate simple_form:install --bootstrap"
  generate_spring_binstubs

  binstubs = %w(
    brakeman bundler-audit
  )
  run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')}"


  unless preexisting_git_repo?
    git :add => "-A ."
    git :commit => "-n -m 'Intializing a new project'"
    git :checkout => "-b development"
  end
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

go_go_template!

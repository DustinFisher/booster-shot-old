RAILS_REQUIREMENT = "~> 4.2.0"

def go_go_template!
  assert_rails_version
  add_template_repository_to_source_path

  copy_file "ruby-versions", ".ruby-versions", :force => true
  copy_file "rbenv-gemsets", ".rbenv-gemsets", :force => true
  copy_file "gitignore", ".gitignore", :force => true
  copy_file "rubocop.yml", ".rubocop.yml", :force => true
  copy_file "Gemfile", "Gemfile", :force => true

  apply "app/template.rb"
  apply "bin/template.rb"
  apply "config/template.rb"

  git :init unless preexisting_git_repo?
  empty_directory ".git/safe"

  run_with_clean_bundler_env "bin/setup"
  generate_spring_binstubs

  run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')}"
end

def assert_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
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

go_go_template!

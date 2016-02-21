# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
    if task_args[:tag].present?
      t.rspec_opts = "--tag #{task_args[:tag]}"
    end
  end
  task default: :spec
rescue LoadError
end

Rails.application.load_tasks

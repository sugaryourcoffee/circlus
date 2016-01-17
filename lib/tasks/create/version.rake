namespace :create do
  desc 'Create application version from git tag'
  task version: :environment do
    File.open('config/version', 'w') do |file|
      file.write `git describe --tags --abbrev=0`
    end
  end
end

namespace :spec do
  desc 'Run rspec against production server instead of local cassettes'
  task :production do
    if ENV['SCALE_TEST_API_KEY'].nil?
      raise 'Please specify SCALE_TEST_API_KEY to run against production server'
    end
    ENV['SCALE_TEST_SERVER'] = 'production'
    Rake::Task['spec'].invoke
  end
end

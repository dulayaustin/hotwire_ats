namespace :tmp do
  namespace :capybara do
    # desc "Clear all files in tmp/capybara"
    task :clear do
      rm Dir["tmp/capybara/[^.]*"], verbose: false
    end
  end
end

task "tmp:clear" => ["tmp:capybara:clear"]
SimpleConfig.for :application do

  set :colours, %w[lightblue red green orange yellow pink blue violet]
  
  load File.join(RAILS_ROOT, 'config', "settings", "#{RAILS_ENV}.rb"), :if_exists? => true
  load File.join(RAILS_ROOT, 'config', "settings", "local.rb"),        :if_exists? => true
  
end

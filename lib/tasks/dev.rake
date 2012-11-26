namespace :dev do
  
  namespace :start do
    desc "Start up the entire application stack"
    task all: ['dev:db:reset', 'dev:rails:restart'] do
    end
  end
  
  namespace :stop do
    desc "Shut down the entire application stack"
    task all: ['dev:rails:stop', 'dev:db:stop'] do
    end
  end
  
  namespace :rails do
    desc "Check if Rails development server is running"
    task :status do
      if `lsof -i :3000 | tail -1` =~ /^ruby/
        puts "Rails server running" 
      else
        puts "Rails server not running"
      end
    end
    
    desc "Start Rails development server"
    task :start do
      if !(`lsof -i :3000 | tail -1` =~ /^ruby/)
        sh %[rails s -d]
      end
      Rake::Task['dev:rails:status'].invoke
    end
    
    desc "Stop Rails development server"
    task :stop do
      port_probe = `lsof -i :3000 | tail -1`.split
      
      if port_probe.first =~ /^ruby/
        sh %[kill -9 #{port_probe[1]}]
      end
      Rake::Task['dev:rails:status'].invoke
    end
    
    desc "Restart Rails development server"
    task restart: ['dev:rails:stop', 'dev:rails:start'] do
      Rake::Task['dev:rails:status'].invoke
    end
  end
  
  namespace :spork do
    desc "Check if Spork server is running"
    task :status do
      if `lsof -i :8989 | tail -1` =~ /^ruby/
        puts "Spork server running" 
      else
        puts "Spork server not running"
      end
    end

    desc "Start Spork server"
    task :start do
      if !(`lsof -i :8989 | tail -1` =~ /^ruby/)
        sh %[spork &]
      end
      Rake::Task['dev:spork:status'].invoke
    end

    desc "Stop Spork server"
    task :stop do
      port_probe = `lsof -i :8989 | tail -1`.split

      if port_probe.first =~ /^ruby/
        sh %[kill -9 #{port_probe[1]}]
      end
      Rake::Task['dev:spork:status'].invoke
    end

    desc "Restart Spork server"
    task restart: ['dev:spork:stop', 'dev:spork:start'] do
      Rake::Task['dev:spork:status'].invoke
    end
  end
  
  namespace :mailtrap do
    desc "Check if mailtrap daemon is running"
    task :status do
      sh %[mailtrap status]
    end
    
    desc "Start mailtrap daemon"
    task :start do
      sh %[mailtrap start] if `mailtrap status` =~ /no instances running/
      Rake::Task['dev:mailtrap:status'].invoke
    end
    
    desc "Stop mailtrap daemon"
    task :stop do
      sh %[mailtrap stop] if !(`mailtrap status` =~ /no instances running/)
      Rake::Task['dev:mailtrap:status'].invoke
    end
      
    desc "Restart mailtrap daemon"
    task restart: ['dev:mailtrap:stop', 'dev:mailtrap:start'] do
      Rake::Task['dev:mailtrap:status'].invoke
    end
  end
  
  namespace :logs do
    desc "List logfiles under current application"
    task :list do
      sh %[find . -type f -name "*.log"]
    end
    
    desc "[show_signed_up|show_invited|open_signed_up|open_invited] from development log"    
    task :url, :action do |t, args|
      args.with_defaults(action: 'show_signed_up')
      log = File.open('log/development.log').readlines
      conf_urls = log.select{ |l| l =~ /href.*http.*confirmation_token/ }.map {|l| l.split(/"/)[1]}
      invited_urls = log.select{ |l| l =~ /href.*http.*invitation_token/ }.map {|l| l.split(/"/)[1]}

      case args.action
        when 'show_signed_up' then puts "Last confirmation URL: #{conf_urls.last}"
        when 'show_invited' then puts "Last confirmation URL: #{invited_urls.last}"
        when 'open_signed_up'
          Rake::Task['dev:rails:start'].invoke
          sh %[open #{conf_urls.last}]
        when 'open_invited'
          Rake::Task['dev:rails:start'].invoke
          sh %[open #{invited_urls.last}]
      end
    end
  end
end

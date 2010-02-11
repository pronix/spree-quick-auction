namespace :spree do
  namespace :extensions do
    namespace :quick_auction do
      desc "Copies public assets of the Quick Auction to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[QuickAuctionExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(QuickAuctionExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end
      desc "Load sample date."
      task :load_test_data => :environment do
        ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
        OptionType.destroy_all
        OptionValue.destroy_all
        Prototype.destroy_all
        fixtures = %w{ option_types.yml option_values.yml prototypes.yml }
        fixtures.each do |fixture_file|
            Fixtures.create_fixtures("#{QuickAuctionExtension.root}/db/sample_fixtures",
                                     File.basename(fixture_file, '.*'))
        end
        Prototype.find_by_name('Shirt').option_types << OptionType.find_by_name('size')
        Prototype.find_by_name('Shirt').option_types << OptionType.find_by_name('sex')
      end
    end
  end
end

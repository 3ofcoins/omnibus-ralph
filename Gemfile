source 'https://rubygems.org'

def fork(repo)
  _local_path = Pathname.new(__FILE__).dirname.dirname.
    join("Forks/#{repo}")
  if ENV['BUNDLE_LOCAL_FORKS'] && _local_path.exist?
    { :path => _local_path.to_s }
  else
    { :git => "git://github.com/3ofcoins/#{repo.sub('/', '-')}.git",
      :branch => "for/#{Pathname.new(__FILE__).dirname.basename}" }
  end
end

gem 'omnibus', '~> 1.0.0', fork('opscode/omnibus-ruby')
gem 'omnibus-software', fork('opscode/omnibus-software')

group :development do
  gem 'pry'
  gem 'pry-rescue'
  gem 'awesome_print'
end

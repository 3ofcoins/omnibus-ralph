require 'bundler/setup'

desc "Tidy up, but don't clean cached downloads"
task :tidy do
  rm_rf Dir['/opt/ralph', '/var/cache/omnibus/build/*', '/var/cache/omnibus/src/*' ]
end

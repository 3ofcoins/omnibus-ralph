require 'digest/md5'
require 'bundler/setup'
require 'omnibus/config'

desc "Check that dynamic linking doesn't point outside Omnibus"
task :checklinks do
  root_dir = '/opt/ralph'
  pipeline = [
    "{ find ./bin -type f ; find . -name '*.so' -or -name '*.dylib' ; }",
    'xargs file',
    'grep Mach-O',
    'cut -d: -f1',
    'xargs otool -L' ]

  [
    '/opt/ralph/embedded/lib',
    '/usr/lib/libSystem.B.dylib',
    '/usr/lib/libgcc_s.1.dylib',
    '/System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration',
    '/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation',
    '/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon',
    # Not sure of libraries below, but let's say they're harmless.
    '/System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices',
    '/System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices'
  ].each do |whitelisted_path|
    pipeline << "grep -v #{whitelisted_path}"
  end

  res = {}
  cur = nil
  `cd /opt/ralph/embedded ; #{pipeline.join(' | ')}`.lines.each do |ln|
    if ln =~ /^\S/
      cur=ln.strip.sub(/^\.\//, '').sub(/:$/, '')
    else
      (res[ln.strip] ||= []) << cur
    end
  end

  res.delete_if { |k,v| v == [] }

  require 'json'
  puts JSON[res]
end

desc "Tidy up, but don't clean cached downloads"
task :tidy do
  rm_rf Dir['/opt/ralph', '/var/cache/omnibus/build/*', '/var/cache/omnibus/src/*' ]
end

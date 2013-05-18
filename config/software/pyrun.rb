require 'yaml'

Config[:pyrun] ||= {}
unicode = Config[:pyrun][:unicode] || 'ucs2' # ucs2, ucs4
python  = Config[:pyrun][:python]  || '2.7'  # 2.7, 2.6, 2.5
meta = YAML.load_file(__FILE__.sub(/\.rb$/, '.yaml'))

name "pyrun"
version "1.2.0-py#{python}"

dependency "openssl"
dependency "zlib"
dependency "sqlite"
dependency "bzip2"

pyrun_platform_spec = "#{OHAI['os']}-#{OHAI['kernel']['machine']}"
pyrun_platform =
  case pyrun_platform_spec
  when 'darwin-x86_64'  then 'macosx-10.5-x86_64'
  when /^darwin-i.86$/  then if OHAI['os_version'].to_i < 10
                               'macosx-10.4-fat'
                             else
                               'macosx-10.5-x86_64'
                             end
  when 'darwin-powerpc' then 'macosx-10.4-fat'
  when 'linux-x86_64'   then 'linux-x86_64'
  when /^linux-i.86$/   then 'linux-i686'
  when 'linux-armv6l'   then 'linux-armv6l'
  when 'freebsd-amd64'  then 'freebsd-8.3-RELEASE-p3-amd64'
  when /^freebsd-i.86$/ then 'freebsd-8.3-RELEASE-p3-i386'
  else
    fail "Unknown platform #{pyrun_platform_spec}"
  end

pyrun_distribution = "egenix-pyrun-#{version}_#{unicode}-#{pyrun_platform}.tgz"
source :url => "https://downloads.egenix.com/python/#{pyrun_distribution}",
       :md5 => meta['md5'][pyrun_distribution]

build do
  # Fix linking to point to Omnibus directory
  case OHAI['os']
  when 'darwin'
    { '/usr/lib/libssl.0.9.8.dylib' => "#{install_dir}/embedded/lib/libssl.dylib",
      '/usr/lib/libcrypto.0.9.8.dylib' => "#{install_dir}/embedded/lib/libcrypo.dylib",
      '/usr/lib/libz.1.dylib' => "#{install_dir}/embedded/lib/libz.dylib"
    }.each do |old_lib, new_lib|
      %w[ pyrun2.7 pyrun2.7-debug ].each do |bin|
        command "install_name_tool -change #{old_lib} #{new_lib} bin/#{bin}"
      end
    end
  else
    warn "FIXME: no dynamic linking fixes on #{platform}"
  end

  command "cp -R . #{install_dir}/embedded/"
end

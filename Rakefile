require 'digest/md5'
require 'yaml'
require 'bundler/setup'
require 'omnibus/config'

desc 'Download all the pyrun variants for checksum'
file 'config/software/pyrun.yaml' do |t|
  md5 = {}
  version = '1.2.0'
  [ 'macosx-10.5-x86_64', 'macosx-10.4-fat', 'macosx-10.4-fat',
    'linux-x86_64', 'linux-i686', 'linux-armv6l',
    'freebsd-8.3-RELEASE-p3-amd64', 'freebsd-8.3-RELEASE-p3-i386'
  ].each do |platform|
    [ '2.7', '2.6', '2.5' ].each do |python|
      [ 'ucs2', 'ucs4' ].each do |unicode|
        distribution =
          "egenix-pyrun-#{version}-py#{python}_#{unicode}-#{platform}.tgz"
        path = File.join(Omnibus::Config[:cache_dir] || '.', distribution)
        sh "wget -m -O #{path} https://downloads.egenix.com/python/#{distribution} || :"
        md5[distribution] = Digest::MD5.file(path).to_s.encode('US-ASCII') if File.exist?(path)
      end
    end
  end

  File.write(t.to_s, YAML.dump('md5' => md5))
end

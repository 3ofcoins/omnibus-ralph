name "ralph"
version "1.2.2"

dependency "pyrun"

# Python deps that need their own libraries.
# TODO: download these and use setup.py?
dependency "python-lxml"
dependency "python-mysql"
dependency "python-pillow"
dependency "python-pycrypto"
dependency "python-pyyaml"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  'PKG_CONFIG_PATH' => "#{libdir}/pkgconfig",
  'CPPFLAGS' => "-I#{prefix}/include",
  'LDFLAGS' => "-L#{libdir}",
  'PIP_DOWNLOAD_CACHE' => "#{cache_dir}/pip",
  'TMPDIR' => "#{source_dir}/pip-tmp",
  'PATH' => "#{prefix}/bin:#{ENV['PATH']}"
}

build do
  FileUtils::mkdir_p env['PIP_DOWNLOAD_CACHE']
  FileUtils::mkdir_p env['TMPDIR']

  # We need to provide `--prefix` to `setup.py install`, as some of
  # `setup.py` scripts do `reload(sys)`, which resets `sys.prefix` to
  # pyrun's temporary install dir rather than pyrun's actual prefix.
  command "#{install_dir}/embedded/bin/pip install ralph==#{version} django-redis-cache --install-option=--prefix=#{prefix}", :env => env
  command "#{install_dir}/embedded/bin/pip freeze > #{prefix}/pip-manifest.txt"

  # Fix paths
  site_packages="#{prefix}/lib/python*/site-packages"
  command "install_name_tool -change libmysqlclient.18.dylib #{prefix}/lib/libmysqlclient.18.dylib #{site_packages}/_mysql.so" if platform == 'mac_os_x'

  block do
    %w[ settings.py util/management/commands/makeconf.py ].each do |script_path|
      script_path = File.join(Dir[site_packages].first, 'ralph', script_path)
      script = File.read(script_path)
      script.gsub!('~/.ralph', "#{install_dir}/sv/ralph")
      File.write(script_path, script)
    end
    FileUtils::ln_sf "#{prefix}/bin/ralph", "#{install_dir}/bin/ralph"
  end
end

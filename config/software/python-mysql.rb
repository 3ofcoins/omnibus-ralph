name "python-mysql"
version '1.2.3'

dependency 'pyrun'

dependency "mysql"

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
  command "#{install_dir}/embedded/bin/pip install MySQL-python==#{version} --install-option=--prefix=#{prefix}", :env => env
end

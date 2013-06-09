name "python-pillow"
version '2.0.0'

dependency 'pyrun'

dependency "lcms"
dependency "libjpeg"
dependency "libpng"
dependency "libtiff"
dependency "freetype"

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
  command "#{install_dir}/embedded/bin/pip install Pillow==#{version} --install-option=--prefix=#{prefix}", :env => env
end

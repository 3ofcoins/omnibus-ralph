name "ralph"
version "1.2.2"

dependency "pyrun"

dependency "libxml2"            # lxml
dependency "libxslt"            # lxml
dependency "libyaml"            # pyyaml
dependency "gmp"                # pycrypto

# Imaging stuff
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
  'TMPDIR' => "#{source_dir}/pip-tmp"
}

build do
  FileUtils::mkdir_p env['PIP_DOWNLOAD_CACHE']
  FileUtils::mkdir_p env['TMPDIR']
  command "#{install_dir}/embedded/bin/pip install ralph==#{version}", :env => env
  command "#{install_dir}/embedded/bin/pip freeze > #{install_dir}/embedded/pip-manifest.txt"
end

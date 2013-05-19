name "pyrun"
version "1.2.0"

basename = "egenix-pyrun-#{version}"
source :url => "https://downloads.egenix.com/python/#{basename}.tar.gz",
       :md5 => "29b3b0b6373d4d02169fdb4f44801c10"
relative_path basename

inline 'python' do
  version '2.7.4'
  source :url => "http://www.python.org/ftp/python/#{version}/Python-#{version}.tgz",
         :md5 => '592603cfaf4490a980e93ecb92bde44a'
end

inline 'distribute' do
  version '0.6.40'
  source :url => "https://pypi.python.org/packages/source/d/distribute/distribute-#{version}.tar.gz",
         :md5 => "7a2dd4033999af22fe9591fa84f3e599"
  relative_path "distribute-#{version}"
end

inline 'pip' do
  version '1.3.1'
  source :url => "https://pypi.python.org/packages/source/p/pip/pip-#{version}.tar.gz",
         :md5 => "cbb27a191cebc58997c4da8513863153"
  relative_path "pip-#{version}"
end

version "#{@pyrun_version ||= version}+py#{inline['python'].version}"

dependency "openssl"
dependency "zlib"
dependency "sqlite"
dependency "bzip2"
dependency "gdbm"
dependency "libedit"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  'PKG_CONFIG_PATH' => "#{libdir}/pkgconfig",
  "CPPFLAGS" => "-I#{prefix}/include",
  "LDFLAGS" => "-L#{libdir}",
  "MACOSX_DEPLOYMENT_TARGET" => '10.5'
}

build do
  command "make PREFIX=#{install_dir}/embedded PYTHONTARBALL=#{inline['python'].project_file}",
          :cwd => "#{project_dir}/PyRun",
          :env => env
  command "make install PREFIX=#{install_dir}/embedded",
          :cwd => "#{project_dir}/PyRun",
          :env => env
  command "rm #{install_dir}/embedded/lib/python*/*/_tkinter.so"
  command "#{install_dir}/embedded/bin/pyrun setup.py install",
          :cwd => inline['distribute'].project_dir,
          :env => env
  command "#{install_dir}/embedded/bin/pyrun setup.py install",
          :cwd => inline['pip'].project_dir,
          :env => env
end

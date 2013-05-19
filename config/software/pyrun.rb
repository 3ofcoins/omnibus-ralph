name "pyrun"
version "1.2.0"

basename = "egenix-pyrun-#{version}"
source :url => "https://downloads.egenix.com/python/#{basename}.tar.gz",
       :md5 => "29b3b0b6373d4d02169fdb4f44801c10"
relative_path basename

dependency "openssl"
dependency "zlib"
dependency "sqlite"
dependency "bzip2"

inline 'python' do
  version '2.7.5'
  source :url => "http://www.python.org/ftp/python/#{version}/Python-#{version}.tgz",
         :md5 => 'b4f01a1d0ba0b46b05c73b2ac909b1df'
end

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  "LDFLAGS" => "-L#{libdir} -R#{libdir} -I#{prefix}/include",
  "CFLAGS" => "-L#{libdir} -R#{libdir} -I#{prefix}/include",
  "LD_RUN_PATH" => libdir
}

build do
  command "make PYTHONFULLVERSION=#{python.version} PREFIX=#{install_dir}/embedded PYTHONTARBALL=#{python.project_file}",
          :cwd => "#{project_dir}/PyRun",
          :env => env
end

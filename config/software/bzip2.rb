name "bzip2"
version "1.0.6"

dependency "zlib"
dependency "openssl"

source :url => "http://www.bzip.org/#{version}/#{name}-#{version}.tar.gz",
       :md5 => "00b516f4704d4a7cb50a1d97e6e8e15b"

relative_path "#{name}-#{version}"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  "LDFLAGS" => "-L#{libdir} -R#{libdir} -I#{prefix}/include",
  "CFLAGS" => "-L#{libdir} -R#{libdir} -I#{prefix}/include",
  "LD_RUN_PATH" => libdir
}

build do
  # Patches from MacPorts
  case OHAI['os']
  when 'darwin' then patch :source => 'Makefile-dylib.patch'
  else               patch :source => 'Makefile-so.patch'
  end

  command "make VERSION=#{version}", :env => env
  command "make install VERSION=#{version} PREFIX=#{prefix}", :env => env
end

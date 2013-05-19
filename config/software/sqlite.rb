name "sqlite"
version "3.7.16.2"

vtag = version.split('.').map { |elt| '%02d' % elt.to_i }.join[1..-1]

source :url => "http://www.sqlite.org/2013/sqlite-autoconf-#{vtag}.tar.gz",
       :md5 => "ce7d2bc0d9b8dd18995b888c6b0b220f"

relative_path "sqlite-autoconf-#{vtag}"

env = {
  "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-readline",
          :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end

name "gmp"
version "5.1.1"

source :url => "ftp://ftp.gnu.org/gnu/gmp/gmp-#{version}.tar.bz2",
       :md5 => "2fa018a7cd193c78494525f236d02dd6"

relative_path "gmp-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib",
  "CPPFLAGS" => "-I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end

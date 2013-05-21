name "liblcms"
version "2.4"

source :url => "http://downloads.sourceforge.net/project/lcms/lcms/#{version}/lcms2-#{version}.tar.gz",
       :md5 => "861ef15fa0bc018f9ddc932c4ad8b6dd"

relative_path "lcms2-#{version}"

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

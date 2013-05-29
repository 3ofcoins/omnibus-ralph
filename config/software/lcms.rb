name "lcms"
version "1.19"

source :url => "http://downloads.sourceforge.net/project/#{name}/#{name}/#{version}/#{name}-#{version}.tar.gz",
       :md5 => "8af94611baf20d9646c7c2c285859818"

relative_path "#{name}-#{version}"

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

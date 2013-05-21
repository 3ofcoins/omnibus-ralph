name "libtiff"
version "4.0.3"

source :url => "http://download.osgeo.org/libtiff/tiff-#{version}.tar.gz",
       :md5 => "051c1068e6a0627f461948c365290410"

relative_path "tiff-#{version}"

dependency "zlib"
dependency "libjpeg"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib",
  "CPPFLAGS" => "-I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --without-x --disable-cxx --disable-lzma", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end

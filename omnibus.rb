# Monkey-patch Omnibus to make it find software not only in
# omnibus-software gem, but also from all other gems that have
# config/software/*.rb files.
module ::Omnibus
  def self.omnibus_software_files
    Array( Gem::Specification.flat_map do |gem|
             Dir[ File.join(gem.gem_dir, "config/software/*.rb") ]
           end )
  end

  class NetFetcher
    alias_method :orig_extract, :extract
    def extract
      if name == 'pyrun'
        p 'pyrun!'
        begin
          _source_dir = @source_dir
          @source_dir = project_dir
          FileUtils::mkdir_p project_dir
          orig_extract
        ensure
          @source_dir = _source_dir
        end
      else
        orig_extract
      end
    end
  end
end

# s3_access_key "something"
# s3_secret_key "something"
# s3_bucket "some-bucket"
# use_s3_caching true
# solaris_compiler "gcc"

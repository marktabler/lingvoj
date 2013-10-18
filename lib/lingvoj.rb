path = File.expand_path('../lingvoj', __FILE__)
Dir.glob(File.join(path, "/**/*.rb")).each { |f| require f }
require 'yaml'

module Lingvoj
  def self.run!(path)
    Assessor.run(path)
  end
end

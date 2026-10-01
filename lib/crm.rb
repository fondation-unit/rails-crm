require "crm/version"
require "crm/engine"
require "zeitwerk"

module Crm
  require "telephone_number"
end

loader = Zeitwerk::Loader.for_gem
loader.setup

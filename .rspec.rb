
require 'coco'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'
end

require 'alfred'
require 'alfred/workflow'
require 'alfred/generator'

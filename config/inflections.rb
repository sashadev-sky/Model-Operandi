require 'active_support/inflector'

# example edge case 'specimen' is overriden below to return 'specimens' (instead of default 'specimen')
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular 'specimen', 'specimens'
end
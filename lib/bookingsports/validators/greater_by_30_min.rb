module ActiveModel
  module Validations
    class GreaterBy30MinValidator < EachValidator
      def validate_each(record, attribute, value)
        if value - record.send(options[:than]) < 30.minutes
          record.errors[attribute] << "can't be less than #{options[:than]} at least 30 min."
        end
      end
    end

    module HelperMethods
      def validates_greater_by_30_min_of(*attr_names)
        validates_with GreaterBy30Min, _merge_attributes(attr_names)
      end
    end
  end
end

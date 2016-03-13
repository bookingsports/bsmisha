module ActiveModel
  module Validations
    class StepBy30MinValidator < EachValidator
      def validate_each(record, attribute, value)
        if value.min % 30 != 0
          record.errors[attribute] << 'minutes can be only 30 or 0'
        end
      end
    end

    module HelperMethods
      def validates_step_30_min_of(*attr_names)
        validates_with StepBy30MinValidator, _merge_attributes(attr_names)
      end
    end
  end
end

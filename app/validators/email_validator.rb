class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        record.errors.add attribute, (options[:message] || " Entered  haha is invalid") unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    end
end
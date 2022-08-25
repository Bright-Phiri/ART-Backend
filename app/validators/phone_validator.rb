class PhoneValidator < ActiveModel::Validator 
    def validate(record)
        unless /\A(\+?(265|0){1}(1|88[0-9]|99[0-9]|98[0-9]|90[0-9]){1}[0-9]{6})\z/.match(record.phone)
            record.errors.add :phone, message: "number is invalid"
        end
    end
end
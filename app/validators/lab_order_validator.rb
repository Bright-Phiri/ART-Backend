class LabOrderValidator < ActiveModel::Validator 
    def validate(record)
        record.errors.add :base, "Lab order already verified" if record.verified == true
    end
end
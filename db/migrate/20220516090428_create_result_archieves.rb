class CreateResultArchieves < ActiveRecord::Migration[6.1]
  def change
    create_table :result_archieves do |t|
      t.string :patient_name
      t.string :blood_type
      t.float :temperature
      t.string :name
      t.belongs_to :lab_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end

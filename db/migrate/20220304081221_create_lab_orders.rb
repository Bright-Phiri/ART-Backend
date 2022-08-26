class CreateLabOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :lab_orders do |t|
      t.string :qrcode
      t.string :blood_type
      t.float :temperature
      t.belongs_to :patient, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end

class AddLabOrdersCountToPatients < ActiveRecord::Migration[7.0]
  def change
    add_column :patients, :lab_orders_count, :integer
  end
end

class RemoveTemperatureFromLabOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :lab_orders, :temperature, :float
  end
end

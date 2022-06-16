class AddStatusToLabOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :lab_orders, :status, :integer
  end
end

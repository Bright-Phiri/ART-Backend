class AddVerifiedToLabOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :lab_orders, :verified, :boolean, default: false
  end
end

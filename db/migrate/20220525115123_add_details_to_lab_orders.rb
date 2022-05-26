class AddDetailsToLabOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :lab_orders, :tissue_name, :string
    add_column :lab_orders, :requested_by, :string
    add_column :lab_orders, :taken_by, :string
  end
end

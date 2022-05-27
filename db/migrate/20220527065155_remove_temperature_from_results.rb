class RemoveTemperatureFromResults < ActiveRecord::Migration[6.1]
  def change
    remove_column :results, :temperature, :float
  end
end

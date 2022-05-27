class RemoveTemperatureFromResultArchieves < ActiveRecord::Migration[6.1]
  def change
    remove_column :result_archieves, :temperature, :float
  end
end

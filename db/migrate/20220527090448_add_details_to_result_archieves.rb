class AddDetailsToResultArchieves < ActiveRecord::Migration[6.1]
  def change
    add_column :result_archieves, :hiv_res, :string
    add_column :result_archieves, :tisuue_res, :text
    add_column :result_archieves, :conducted_by, :string
  end
end

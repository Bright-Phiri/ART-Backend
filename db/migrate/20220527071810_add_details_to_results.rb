class AddDetailsToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :hiv_res, :string
    add_column :results, :tisuue_res, :text
    add_column :results, :conducted_by, :string
  end
end

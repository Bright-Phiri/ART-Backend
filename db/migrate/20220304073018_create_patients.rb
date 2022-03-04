class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :dob
      t.string :district
      t.string :village
      t.string :phone
      t.string :location

      t.timestamps
    end
  end
end

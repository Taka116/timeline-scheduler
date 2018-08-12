class CreateUnivClassDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :univ_class_details do |t|
      t.belongs_to :univ_class, foreign_key: true, index: true, null: true
      t.string :day
      t.string :period
      t.string :classroom
      t.timestamps
    end
  end
end

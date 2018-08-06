class CreateUnivClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :univ_classes do |t|
      t.string :class_code
      t.string :subject_name
      t.string :professor
      t.string :period
      t.string :classroom
      t.timestamps
    end
  end
end

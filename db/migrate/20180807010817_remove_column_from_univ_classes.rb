class RemoveColumnFromUnivClasses < ActiveRecord::Migration[5.2]
  def change
    remove_column :univ_classes, :period, :string
    remove_column :univ_classes, :classroom, :string
    add_index :univ_classes, [:class_code, :subject_name, :professor]
  end
end

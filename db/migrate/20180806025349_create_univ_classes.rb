class CreateUnivClasses < ActiveRecord::Migration[5.2]
  def change
    create_table :univ_classes do |t|
      t.string :class_code, null: false
      t.string :subject_name, null: false
      t.string :professor, null: false
      t.integer :level, null: true
      t.integer :number_of_credit, null: false
      t.string :class_url, null: false
      t.text :content_of_class, null: true
      t.text :exam_evaluation, null: true
      t.text :report_evaluation, null: true
      t.text :normal_evaluation, null: true
      t.text :other_evaluation, null: true
      
      t.timestamps
    end
    add_index :univ_classes, [:class_code, :subject_name, :professor]
  end
end

# level,number_of_credit,content_of_class,evaluation_system,class_url

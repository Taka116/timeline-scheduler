class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :univ_class, null: false, foreign_key: true
      t.timestamps
    end
  end
end

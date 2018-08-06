class AddAssociationToUnivClasses < ActiveRecord::Migration[5.2]
  def change
    add_reference :univ_classes, :user, index: true, foreign_key: true
  end
end

class UnivClass < ApplicationRecord
    require 'csv'
    
    belongs_to :user, optional: true
    
    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            UnivClass.create! row.to_hash
        end
    end
end

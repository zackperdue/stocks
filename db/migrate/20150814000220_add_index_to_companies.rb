class AddIndexToCompanies < ActiveRecord::Migration
  def change
    add_index :companies, :sector_id
  end
end

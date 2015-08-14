class AddIndustryIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :industry_id, :integer
    add_index :companies, :industry_id
  end
end

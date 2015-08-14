class RemoveIndustryFromCompany < ActiveRecord::Migration
  def change
    remove_column :companies, :industry
  end
end

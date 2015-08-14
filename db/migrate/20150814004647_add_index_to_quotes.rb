class AddIndexToQuotes < ActiveRecord::Migration
  def change
    add_index :quotes, :company_id
  end
end

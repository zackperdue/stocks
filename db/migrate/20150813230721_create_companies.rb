class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :symbol
      t.string :name
      t.float :last_sale
      t.float :market_cap
      t.string :ipo_year
      t.integer :sector_id
      t.string :industry
      t.string :summary_quote

      t.timestamps null: false
    end
  end
end

class AddTimestampToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :timestamp, :bigint
  end
end

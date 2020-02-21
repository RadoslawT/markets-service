# frozen_string_literal: true

# :nodoc:
class ChangeColumnsInMarkets < ActiveRecord::Migration[6.0]
  def change
    add_column :markets, :ask_price, :float, default: nil
    add_column :markets, :bid_price, :float, default: nil
    rename_column :markets, :price, :avrage_price
  end
end

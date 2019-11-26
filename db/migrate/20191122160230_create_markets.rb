# frozen_string_literal: true

# :nodoc:
class CreateMarkets < ActiveRecord::Migration[6.0]
  def change
    create_table :markets do |t|
      t.uuid :uuid, default: 'uuid_generate_v4()'
      t.string :platform, null: false
      t.string :name, null: false
      t.float :price, default: nil

      t.index [:platform, :name], unique: true

      t.timestamps
    end
  end
end

# frozen_string_literal: true

# :nodoc:
class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.uuid :uuid, default: 'uuid_generate_v4()'
      t.string :market_uuid, null: false
      t.string :type, null: false
      t.float :completion_price, null: false

      t.index [:market_uuid, :type, :completion_price], unique: true

      t.timestamps
    end
  end
end

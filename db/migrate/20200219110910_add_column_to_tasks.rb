# frozen_string_literal: true

# :nodoc:
class AddColumnToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :activation_price, :float, null: false
  end
end

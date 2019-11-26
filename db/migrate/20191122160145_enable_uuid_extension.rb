# frozen_string_literal: true

# :nodoc:
class EnableUuidExtension < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'uuid-ossp'
  end
end

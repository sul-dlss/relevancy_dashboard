class AddScoreToSearch < ActiveRecord::Migration[5.2]
  def change
    add_column :searches, :score, :decimal
  end
end

class UpdateResponseSize < ActiveRecord::Migration[5.2]
  def change
    change_column :search_results, :response, :text, limit: 16.megabytes
  end
end

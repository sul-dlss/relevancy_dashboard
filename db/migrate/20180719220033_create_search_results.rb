class CreateSearchResults < ActiveRecord::Migration[5.2]
  def change
    create_table :search_results do |t|
      t.text :response
      t.references :endpoint, foreign_key: true
      t.references :search, foreign_key: true

      t.timestamps
    end
  end
end

class CreateDeveloperShowcases < ActiveRecord::Migration[5.2]
  def change
    create_table :developer_showcases do |t|
      t.string :url

      t.timestamps
    end
  end
end

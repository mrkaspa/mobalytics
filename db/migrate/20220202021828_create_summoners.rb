class CreateSummoners < ActiveRecord::Migration[7.0]
  def change
    create_table :summoners, id: false, primary_key: :id do |t|
      t.string :id
      t.string :account_id
      t.string :puuid
      t.string :name
      t.integer :profile_icon_id
      t.integer :revision_date
      t.integer :summoner_level

      t.timestamps
    end
  end
end

class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :common_name
      t.string :legal_name
      t.string :oauth2_token
      t.string :oauth2_token_mark
      t.string :access_email

      t.timestamps null: false
    end
  end
end

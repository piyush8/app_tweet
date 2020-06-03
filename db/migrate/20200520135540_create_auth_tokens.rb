class CreateAuthTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_tokens do |t|
      t.string :token
      t.references :user

      t.timestamps
    end
  end
end

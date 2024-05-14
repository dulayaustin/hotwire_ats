class CreateApplicants < ActiveRecord::Migration[7.1]
  def change
    create_table :applicants, id: :uuid do |t|
      t.references :job, null: false, foreign_key: true, type: :uuid
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :stage
      t.string :status

      t.timestamps
    end
    add_index :applicants, :email
    add_index :applicants, :stage
    add_index :applicants, :status
  end
end

class AddCommentableCountToApplicants < ActiveRecord::Migration[7.1]
  def change
    add_column :applicants, :commentable_count, :integer
  end
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: :commentable_count, touch: true

  has_rich_text :comment

  after_create_commit :notify_mentioned_users

  def notify_mentioned_users
    mentioned_users.each do |mentioned_user|
      NotifyUserJob.perform_later(
        resource_id: id,
        resource_type: 'Comment',
        user_id: mentioned_user.id
      )
    end
  end

  def create_notification(mentioned_user)
    ApplicantCommentNotification.create(
      user: mentioned_user,
      params: {
        user: user,
        applicant: commentable
      }
    )
  end

  def mentioned_users
    comment.body.attachments.select { |att| att.attachable.is_a?(User) }.map(&:attachable).uniq
  end
end

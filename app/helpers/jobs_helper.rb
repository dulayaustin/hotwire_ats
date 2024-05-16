module JobsHelper
  def job_options_for_select
    Job.where(account_id: current_user.account_id).order(:title).pluck(:title, :id)
  end
end

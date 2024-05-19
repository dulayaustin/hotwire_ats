module JobsHelper
  def job_options_for_select
    Job.where(account_id: current_user.account_id).order(:title).pluck(:title, :id)
  end

  def job_sort_options_for_select
    [
      ['Posting Date Ascending', 'created_at-asc'],
      ['Posting Date Descending', 'created_at-desc'],
      ['Title Ascending', 'title-asc'],
      ['Title Descending', 'title-desc']
    ]
  end

  def job_status_options_for_select
    Job.statuses.values.map{ |value| [value.humanize, value] }
  end
end

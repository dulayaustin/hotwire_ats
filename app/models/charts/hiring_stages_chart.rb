class Charts::HiringStagesChart
  def initialize(account_id)
    @account_id = account_id
  end

  def generate
    query_data
  end

  def query_data
    Applicant
      .includes(:job)
      .for_account(@account_id)
      .group('stage')
      .count
  end
end
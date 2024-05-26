class DashboardController < ApplicationController
  def show
    report_data = Charts::ApplicantsChart.new(current_user.account_id).generate
    @categories = report_data.keys.to_json
    @series = report_data.values.to_json

    report_data = Charts::HiringStagesChart.new(current_user.account_id).generate
    @stage_labels = report_data.keys.map(&:humanize).to_json
    @stage_series = report_data.values.to_json
  end
end

class ChartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chart

  def show
    report_data = @chart.constantize.new(current_user.account_id).generate
    keys = report_data.keys
    keys = keys.map(&:humanize) if @chart.include?('HiringStagesChart')
    @labels = keys.to_json
    @series = report_data.values.to_json
    @chart_partial = chart_to_partial
  end

  private

    def set_chart
      @chart = params[:chart_type]
    end

    def chart_to_partial
      @chart.gsub('Charts::', '').underscore
    end
end

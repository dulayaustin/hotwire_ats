module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice
      'bg-blue-900 border-blue-900'
    when :success
      'bg-green-900 border-green-900'
    when :alert
      'bg-red-900 border-red-900'
    when :error
      'bg-red-900 border-red-900'
    else
      'bg-blue-900 border-blue-900'
    end
  end

  def fetch_filter_key(resource, user_id, key)
    Kredis.hash("#{resource}_filters:#{user_id}")[key]
  end
end
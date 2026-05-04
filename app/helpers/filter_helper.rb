module FilterHelper
  def active_filter?(filter_name, value)
    Array(current_filters[filter_name]).map(&:to_s).include?(value.to_s)
  end
end

module Crm
  module ApplicationHelper
    def date_readable(date)
      time_zone_date(date).strftime("%d/%m/%Y %H:%M")
    end

    def flash_class(level)
      {
        notice: "alert alert-success",
        success: "alert alert-success",
        error: "alert alert-error",
        alert: "alert alert-danger"
      }[
        level.to_sym
      ]
    end

    private

    def time_zone_date(date)
      if !date.instance_of?(ActiveSupport::TimeWithZone)
        return Time.zone.parse(date)
      end

      date
    end

    def is_active?()
      if current_page?(member_types_path) ||
          current_page?(investments_path) ||
          current_page?(disciplines_path) ||
          current_page?(levels_path)
        "show"
      else
        ""
      end
    end
  end
end

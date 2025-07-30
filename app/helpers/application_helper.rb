module ApplicationHelper
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

  def options_for_enum(model_class, enum)
    enum_hash = model_class.send(enum.to_s.pluralize)

    enum_hash.map do |key, value|
      [model_class.human_attribute_name("#{enum}.#{key}"), value]
    end
  end
end

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
end

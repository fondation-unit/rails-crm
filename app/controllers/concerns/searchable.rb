# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    attr_accessor :searched_attrs, :filters_attrs
    attr_writer :class_name, :request_path

    before_action :set_search_sort_params
  end

  def class_name
    @class_name ||= controller_name.classify.constantize
  end

  def request_path
    @request_path ||= controller_name
  end

  def set_search_sort_params
    session[:sort] = params[:sort] if params[:sort].present?
    session[:order] = params[:order] if params[:order].present?
  end

  def search(template:, klass: class_name)
    cleaned_param = params[:searched_param]&.strip&.squeeze(" ")

    results =
      if cleaned_param.present?
        build_search_query(cleaned_param, klass)
      else
        klass.all # Alternative to "1=1"
      end

    @pagy, @records = pagy(results)

    respond_to do |format|
      format.html { render template }
      format.turbo_stream do
        render turbo_stream:
                 turbo_stream.update(
                   "search_results",
                   partial: template,
                   locals: {
                     records: @records,
                     pagy: @pagy,
                     page: params[:page]
                   }
                 )
      end
    end
  end

  private

  def build_search_query(search_param, klass)
    # Validate searched_attrs to ensure they're actual model attributes
    validate_searched_attributes(klass)

    search_terms = search_param.split(" ")
    # Build conditions for each term safely
    search_terms.reduce(klass) do |relation, term|
      term_conditions =
        searched_attrs.map do |attr|
          klass.arel_table[attr].matches("%#{term}%")
        end
      combined = term_conditions.reduce(:or)
      relation.where(combined)
    end
  end

  def validate_searched_attributes(klass)
    return if searched_attrs.blank?

    # Ensure searched_attrs only contains valid column names
    valid_columns = klass.column_names.map(&:to_s)
    # Convert searched_attrs to strings for comparison
    searched_attrs_as_strings = searched_attrs.map(&:to_s)
    invalid_attrs = searched_attrs_as_strings - valid_columns

    if invalid_attrs.any?
      raise ArgumentError,
            "Invalid search attributes: #{invalid_attrs.join(", ")}"
    end
  end

  def safe_attribute?(attr, klass)
    # Only allow actual model column names
    klass.column_names.include?(attr.to_s)
  end
end

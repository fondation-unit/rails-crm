module FullTextSearchable
  extend ActiveSupport::Concern

  included do
    # Searches users by first name, last name, and email using Postgres full-text search.
    # Uses the 'simple' dictionary (no stemming) for accurate name/email matching.
    # Supports prefix matching: "foo" matches "foobar".
    #
    # @param query [String] the search string (e.g. "foo", "john doe")
    # @return [ActiveRecord::Relation] matching users
    scope :search,
          ->(query) do
            return none if query.blank?

            where(
              "search_vector @@ to_tsquery('simple', ?)",
              build_tsquery(query)
            )
          end

    # Same as `scope :search` but orders results by relevance using Postgres ts_rank.
    # More relevant matches appear first (e.g. exact prefix on last name).
    #
    # @param query [String] the search string
    # @return [ActiveRecord::Relation] matching users with a virtual +rank+ attribute (Float)
    scope :search_ranked,
          ->(query) do
            return none if query.blank?

            tsquery = build_tsquery(query)
            rank_expr =
              sanitize_sql_array(
                [
                  "ts_rank(#{table_name}.search_vector, to_tsquery('simple', ?))",
                  tsquery
                ]
              )

            where(
              "#{table_name}.search_vector @@ to_tsquery('simple', ?)",
              tsquery
            ).select("#{table_name}.*, #{rank_expr} AS rank").order(
              Arel.sql("#{rank_expr} DESC")
            )
          end
  end

  class_methods do
    # Sanitizes input and converts each word into a prefix tsquery term.
    # "marie d" -> "marie:* & d:*"
    #
    # @param query [String]
    # @return [String] a to_tsquery-compatible prefix expression
    def build_tsquery(query)
      query
        .gsub(
          /[!&|():*]/,
          " "
        ) # strip tsquery special characters to prevent injection
        .squish
        .split
        .map { |w| "#{connection.quote_string(w)}:*" }
        .join(" & ")
    end
  end
end

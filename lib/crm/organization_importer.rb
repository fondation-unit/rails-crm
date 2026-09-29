require "csv"

module Crm
  class OrganizationImporter
    def initialize(file, user:)
      @file = file
      @user = user
    end

    def call
      CSV.foreach(
        @file.path,
        headers: true,
        encoding: "bom|utf-8",
        col_sep: ";"
      ) do |row|
        normalized_row =
          CSV::Row.new(row.headers.map { |h| normalize_header(h) }, row.fields)

        ImportOrganizationJob.perform_async(user.id, normalized_row.to_h)
      end
    end

    private

    attr_reader :user

    def normalize_header(header)
      # Normalisation des entêtes pour éviter les problèmes d'espaces multiples
      header.to_s.strip.gsub(/\s+/, " ")
    end
  end
end

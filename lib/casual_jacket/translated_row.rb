module CasualJacket

  class TranslatedRow

    attr_reader :headers, :legend, :group_header, :csv_row

    def initialize(headers, legend, group_header, csv_row)
      @headers      = headers
      @legend       = legend
      @group_header = group_header
      @csv_row      = csv_row
    end

    def group
      csv_row[group_header]
    end

    def attributes
      legend.keys.each_with_object({}) do |header, attributes|
        attributes.merge! translated_header(header)
      end
    end

    private

    def untranslated_headers
      headers - legend.keys
    end

    def translated_header(header)
      legend[header].each_with_object({}) do |attribute, translated_hash|
        translated_hash[attribute] = csv_row[header]
      end
    end

  end

end

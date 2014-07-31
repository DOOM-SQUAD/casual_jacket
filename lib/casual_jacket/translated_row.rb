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
      translated_values.merge(untranslated_values)
    end

    private

    def untranslated_headers
      headers - legend.keys
    end

    def translated_values
      legend.keys.each_with_object({}) do |header, attributes|
        attributes.merge! translated_header(header)
      end
    end

    def translated_header(header)
      legend[header].each_with_object({}) do |attribute, translated_hash|
        translated_hash[attribute] = csv_row[header]
      end
    end

    def untranslated_values
      untranslated_headers.each_with_object({}) do |header, attributes|
        attributes[header] = csv_row[header]
      end
    end

  end

end

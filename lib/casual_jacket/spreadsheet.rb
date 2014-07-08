module CasualJacket

  class Spreadsheet

    attr_reader :legend, :group_header

    def initialize(file_contents, legend, group_header)
      @file_contents = file_contents
      @legend        = legend
      @group_header  = group_header
    end

    def headers
      parsed_data.headers
    end

    def translated_rows(&block)
      rows.each.with_index(1) do |row, index|
        yield index, row, find_group(row) if block_given?
      end
    end

    def grouping_attribute
      legend.fetch(group_header, group_header)
    end

    def parsed_data
      @parsed_data ||= CSV.parse(fake_file, headers: :first_row)
    end

    private

    def fake_file
      StringIO.new(@file_contents)
    end

    def rows
      parsed_data.map do |row|
        build_translated_row(row)
      end
    end

    def build_translated_row(row)
      Hash.new.tap do |translated_row|
        row.each do |key, value|
          set_translation(translated_row, key, value)
        end
      end
    end

    def set_translation(translated_row, key, value)
      translation_key = legend.fetch(key, key)
      translated_row[translation_key] = value
    end

    def find_group(row)
      row[grouping_attribute]
    end

  end

end

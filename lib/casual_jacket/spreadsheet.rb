module CasualJacket

  class Spreadsheet

    attr_reader :legend, :group_header

    def initialize(file, legend, group_header)
      @file         = file
      @legend       = legend
      @group_header = group_header
      @parsed_data  = CSV.parse(@file, headers: :first_row)

      unless legend[group_header]
        raise Errors::InvalidGroupHeader.new(group_header)
      end
    end

    def headers
      @parsed_data.headers
    end

    def translated_rows(&block)
      rows.each.with_index(1) do |row, index|
        yield index, row, find_group(row) if block_given?
      end
    end

    def grouping_attribute
      legend[group_header]
    end

    def group_list
    end

    private

    def rows
      @parsed_data.map do |row|
        build_translated_row(row)
      end
    end

    def build_translated_row(row)
      Hash.new.tap do |translated_row|
        row.each do |key, value|
          translated_row[legend[key]] = value
        end
      end
    end

    def find_group(row)
      row[grouping_attribute]
    end

  end

end

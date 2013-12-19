module CasualJacket

  class Spreadsheet

    attr_reader :legend

    def initialize(file, legend)
      @file        = file
      @legend      = legend
      @parsed_data = CSV.parse(@file, headers: :first_row)
    end

    def headers
      @parsed_data.headers
    end

    def translated_rows(&block)
      rows.each do |row|
        yield row if block_given?
      end
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

  end

end

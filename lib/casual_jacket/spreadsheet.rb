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

    def parsed_data
      @parsed_data ||= CSV.parse(fake_file, headers: :first_row)
    end

    def each_translated_row(&block)
      parsed_data.to_enum.with_index(1) do |row, index|
        translated_row = translate_row(row)
        yield index, translated_row.attributes, translated_row.group if block_given?
      end
    end

    private

    def fake_file
      StringIO.new(@file_contents)
    end

    def translate_row(row)
      TranslatedRow.new(headers, legend, group_header, row)
    end

  end

end

require 'spec_helper'

describe CasualJacket::Spreadsheet do

  let(:header_row)   { "header1,header2,untranslated_header" }
  let(:body_row1)    { "body11,body12,body13" }
  let(:body_row2)    { "body21,body22,body23" }
  let(:legend)       { { "header1" => "size", "header2" => "stank" } }
  let(:group_header) { "header2" }

  let(:csv_string) { "#{header_row}\n#{body_row1}\n#{body_row2}" }

  let(:file) { StringIO.new(csv_string) }

  let(:spreadsheet) do
    CasualJacket::Spreadsheet.new(file, legend, group_header)
  end

  describe '#headers' do

    it 'returns the row of headers' do
      expect(spreadsheet.headers).to eq(header_row.split(','))
    end

  end

  describe '#translated_rows' do

    let(:row0)   { { "size" => "body11", "stank" => "body12", "untranslated_header" => "body13" } }
    let(:row1)   { { "size" => "body21", "stank" => "body22", "untranslated_header" => "body23" } }
    let(:result) { [row0, row1] }

    it 'returns spreadsheet rows appropriately modified by the legend' do
      expect(spreadsheet.translated_rows).to eq(result)
    end

  end

  describe 'grouping' do

    it 'reports the attribute for grouping' do
      expect(spreadsheet.grouping_attribute).to eq("stank")
    end

  end

end

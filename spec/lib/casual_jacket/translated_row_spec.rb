require 'spec_helper'

describe CasualJacket::TranslatedRow do

  let(:header_row)    { "header1,header2,untranslated_header" }
  let(:body_row1)     { "body11,body12,body13" }
  let(:legend)        { { "header1" => ["size"], "header2" => ["stank", "copied_attribute"] } }
  let(:group_header)  { "header2" }
  let(:file_contents) { "#{header_row}\n#{body_row1}" }

  let(:csv_file) { CSV.parse(StringIO.new(file_contents), headers: :first_row) }

  let(:row) { csv_file.first }

  let(:translated_row) do
    CasualJacket::TranslatedRow.new(csv_file.headers, legend, group_header, row)
  end

  describe '#group' do

    let(:expected_group) { "body12" }

    it 'produces the expected string' do
      expect(translated_row.group).to eq(expected_group)
    end

  end

  describe '#attributes' do

    let(:expected_attributes) do
      {
        "size"                => "body11",
        "stank"               => "body12",
        "copied_attribute"    => "body12",
        "untranslated_header" => "body13"
      }
    end

    it 'produces the expected hash' do
      expect(translated_row.attributes).to eq(expected_attributes)
    end

  end

end

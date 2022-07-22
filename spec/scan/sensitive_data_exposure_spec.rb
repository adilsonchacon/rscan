require './scan/sensitive_data_exposure.rb'

describe Scan::SensitiveDataExposure do
  describe "Catch Sensitive Data Exposure" do
    context 'When "Checkmarks", "Hellman & Friedman" and "$1.15b" are all present in same line' do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/sensitive_data_expo.txt"
      expo = Scan::SensitiveDataExposure.new(target_file)
      expo.parse
      it { expect(expo.report).to be_a(Array) }
      it { expect(expo.report.size).to eq(1) }
      it { expect(expo.report[0]).to include(line: 24) }
      it { expect(expo.report[0]).to include(file: target_file) }
      it { expect(expo.report[0]).to include(vulnerability: 'Sensitive Data Exposure') }
    end
  end


  describe "Catch Sensitive Data Exposure" do
    context 'When "Checkmarks", "Hellman & Friedman" or "$1.15b" is missed in same line' do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/no_sensitive_data_expo.txt"
      expo = Scan::SensitiveDataExposure.new(target_file)
      expo.parse
      it { expect(expo.report).to be_a(Array) }
      it { expect(expo.report.size).to eq(0) }
    end
  end
end

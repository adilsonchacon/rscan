require './scan/xss.rb'

describe Scan::Xss do
  describe "Catch alert" do
    context "From events on HTML files" do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/xss_alert.html"
      xss = Scan::Xss.new(target_file)
      xss.parse
      it { expect(xss.report).to be_a(Array) }
      it { expect(xss.report.size).to eq(2) }
      it { expect(xss.report[0]).to include(line: 3) }
      it { expect(xss.report[0]).to include(file: target_file) }
      it { expect(xss.report[0]).to include(vulnerability: 'XSS') }
      it { expect(xss.report[1]).to include(line: 10) }
      it { expect(xss.report[1]).to include(file: target_file) }
      it { expect(xss.report[1]).to include(vulnerability: 'XSS') }
    end

    context "From Javascript files" do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/xss_alert.js"
      xss = Scan::Xss.new(target_file)
      xss.parse
      it { expect(xss.report).to be_a(Array) }
      it { expect(xss.report.size).to eq(1) }
      it { expect(xss.report[0]).to include(line: 3) }
      it { expect(xss.report[0]).to include(file: target_file) }
      it { expect(xss.report[0]).to include(vulnerability: 'XSS') }
    end
  end


  describe "Does not catch alert" do
    context "On HTML events which has no alert" do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/no_xss_alert.html"
      xss = Scan::Xss.new(target_file)
      xss.parse
      it { expect(xss.report).to be_a(Array) }
      it { expect(xss.report.size).to eq(0) }
    end

    context "If HTML events does not have alert" do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/no_xss_alert.js"
      xss = Scan::Xss.new(target_file)
      xss.parse
      it { expect(xss.report).to be_a(Array) }
      it { expect(xss.report.size).to eq(0) }
    end
  end
end

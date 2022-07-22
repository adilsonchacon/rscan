require './scan/sql_injection.rb'

describe Scan::SqlInjection do
  describe "Catch SQL Injection" do
    context 'When "SELECT", "WHERE" and "%s" are between quotes' do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/sqli.go.fake"
      sqli = Scan::SqlInjection.new(target_file)
      sqli.parse
      it { expect(sqli.report).to be_a(Array) }
      it { expect(sqli.report.size).to eq(2) }
      it { expect(sqli.report[0]).to include(line: 6) }
      it { expect(sqli.report[0]).to include(file: target_file) }
      it { expect(sqli.report[0]).to include(vulnerability: 'SQL Injection') }
      it { expect(sqli.report[1]).to include(line: 10) }
      it { expect(sqli.report[1]).to include(file: target_file) }
      it { expect(sqli.report[1]).to include(vulnerability: 'SQL Injection') }
    end
  end


  describe "Does not catch SQL Injection" do
    context 'When "SELECT", "WHERE" or "%s" is missed in quotes' do
      target_file = "#{"#{File.dirname(__FILE__)}"}/../fixtures/no_sqli.go.fake"
      sqli = Scan::SqlInjection.new(target_file)
      sqli.parse
      it { expect(sqli.report).to be_a(Array) }
      it { expect(sqli.report.size).to eq(0) }
    end
  end
end

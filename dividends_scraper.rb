# scrapes upcoming stock dividends 
require 'nokogiri'
require 'open-uri'
require 'yaml'

URL = 'http://www.morningstar.com.au/Stocks/UpcomingDividends'

page = Nokogiri::HTML(open(URL))  
rows = page.css('div#wrapper div#maincontent div.LayerFatter5 table#OverviewTable.table2.tablesorter.dividendhisttable tr')
outFile = File.open(File.expand_path('upcomingdvidends.yaml',File.dirname(__FILE__)),'w')

stocks = rows.map do |row|
	stock = row.css('td').each_with_index.map do |el,index|
		 el.text.gsub(/\s+/,'')
	end
end

stocks.each do |stock|
	code, name, ex_div_date, div_pay_date, amount, franking = stock 
	unless code.nil? || code.length > 3 
		outFile.puts ({code: code, name: name, ex_div_date: ex_div_date, div_pay_date: div_pay_date, amount: amount, franking: franking}.to_yaml) 
		puts "Added #{code} to file}"
	end
end
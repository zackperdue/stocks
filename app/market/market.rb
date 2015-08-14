require 'net/http'
require 'csv'
require 'monetize'

module Market
  def self.sync_sectors
    sectors.each do |sector|
      Sector.find_or_create_by(name: sector)
    end
  end

  def self.sectors(*block)
    sectors = []
    companies do |c|
      sectors << c[5]
    end
    sectors.uniq
  end

  def self.sync_company(company, from, to, interval = 'd')
    quote_data = download_quote_data(company.symbol, from, to, interval)
    begin
    CSV.parse(quote_data).drop(1)
      .each_with_index do |quote, i|
        Quote.find_or_create_by(
          company_id: company.id,
          date: Date.parse(quote[0]).to_date,
          interval: interval
        ).update_attributes(
          open: quote[1],
          high: quote[2],
          low: quote[3],
          close: quote[4],
          volume: quote[5],
          adj_close: quote[6],
          timestamp: (Date.parse(quote[0]).to_datetime.to_i * 1000)
        )
      end
    rescue Exception => e
      puts e.inspect
    end
  end

  def self.sync_companies
    companies do |c, i|
      Company.find_or_create_by(symbol: c[0]).update_attributes(
        name: c[1],
        last_sale: c[2],
        market_cap: Monetize.parse(c[3]).to_f,
        ipo_year: c[4],
        sector_id: Sector.find_by(name: c[5]).id,
        industry_id: Industry.find_by(name: c[6]).id,
        summary_quote: c[7]
      )
    end
  end

  def self.companies(*block)
    CSV.parse(download_companies).drop(1).each_with_index do |company, i|
      yield company, i if block_given?
    end
  end

  def self.sync_quotes
    from = Time.zone.now - 2.years
    to = Time.zone.now
    interval = 'd'
    Company.all.select(:symbol, :id).each_slice(Company.count) do |company|
      company.map do |c|
        Thread.new do
          sync_company(c, from, to, interval)
        end
      end.each(&:join)
    end
  end

  def self.download_quote_data(symbol, from, to, interval = 'd')
    url = [
      'http://ichart.yahoo.com/table.csv?',
      "s=#{symbol}",
      "&a=#{from.month - 1}",
      "&b=#{from.day}",
      "&c=#{from.year}",
      "&d=#{to.month - 1}",
      "&e=#{to.day}",
      "&f=#{to.year}",
      "&g=#{interval}",
      '&ignore=.csv'
    ]
    uri = URI(url.join)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.body
  end

  def self.download_companies
    uri = URI('http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nasdaq&render=download')
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.body
  end
end

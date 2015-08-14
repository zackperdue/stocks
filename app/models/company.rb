class Company < ActiveRecord::Base
  belongs_to :sector
  belongs_to :industry
  has_many :quotes

  def to_param
    symbol
  end

  def percent_change
    quote = quotes.order(date: :desc).first
    ((quote.open - quote.close) / quote.open) * 100
  end

  def news
    # JSON.parse download_news
  end

  private


  def download_news
    uri = URI("https://www.google.com/finance/company_news?q=#{symbol}&output=json")
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.body
  end
end

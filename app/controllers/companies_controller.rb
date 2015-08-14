class CompaniesController < ApplicationController
  before_filter :set_company, only: [:show, :history]

  def index
    @companies = Company.all
  end

  def show
    @related = @company.industry.companies.where.not(id: @company.id)
  end

  def search
    ticker = params[:q].presence
    company = Company.where("symbol = ? or name ilike ?", ticker, "%#{ticker}%")
    redirect_to company_path(company.first.try(:symbol)) if company
  end

  def history
    render json: {
      company: @company,
      history: @company.quotes.order(timestamp: :asc).where('date >= ?', Time.zone.now - 1.years)
    }, status: :ok
  end

  private

  def set_company
    @company = Company.find_by(symbol: params[:id].try(:upcase))
  end
end

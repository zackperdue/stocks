class SectorsController < ApplicationController
  def show
    @sector = Sector.find(params[:id])
    @companies = @sector.companies
  end
end

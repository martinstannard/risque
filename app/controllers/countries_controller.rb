class CountriesController < ApplicationController

  def show
    country = Country.find(params[:id])
    respond_to do |format|
      format.js do
        render :json => country.to_json
      end
    end
  end

end

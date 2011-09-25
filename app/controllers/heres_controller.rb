class HeresController < ApplicationController
  before_filter :make_location
  before_filter :check_location, :except => :show
  respond_to :html
  respond_to :xml, :only => :create
  
  def show
  end
  
  def create
    logger.debug "location is #{@location[:lng]}, #{@location[:lat]}"
    @tweets = Tweet.where(:location.near => [@location[:lng], @location[:lat]]).order('when DESC').limit(50)
    respond_with(@tweets) do |format|
      format.html { render :show }
    end
  end
  
  private
  
  def make_location
    @location = {}
    @location[:lat] = ""
    @location[:lng] = ""
  end
  
  def check_location
    if (params[:lattitude].blank? || params[:longitude].blank?)
      flash[:error] = "Please fill in both lattitude and longitude"
      render :show
      return
    end
    @location[:lat] = params[:lattitude].to_f
    @location[:lng] = params[:longitude].to_f
    unless loc_valid? @location
      flash[:error] = "Coordinates are not in range. Long: +/- 180, Lat: +/- 90"
      render :show
    end
  end
end

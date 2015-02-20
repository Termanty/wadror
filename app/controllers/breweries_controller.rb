class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_admin_status, only: :destroy

  def index
    def index
      @active_breweries = Brewery.active
      @retired_breweries = Brewery.retired
    end
  end

  def show
  end

  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end

  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    def brewery_params
      params.require(:brewery).permit(:name, :year, :activity)
    end

    def authenticate
      admin_accounts = { "admin" => "secret", "pekka" => "beer", "arto" => "foobar", "matti" => "ittam"}

      authenticate_or_request_with_http_basic do |username, password|
        dfadfdsa
        permission = false
        admin_accounts.each do |user, psw|
          if username == user and password == psw
            permission = true
          end
        end
        permission
      end
    end
end

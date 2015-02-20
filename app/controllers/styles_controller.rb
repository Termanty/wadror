class StylesController < ApplicationController
  before_action :ensure_admin_status, only: :destroy

  def index
    @styles = Style.all
  end

  def show
    @style = Style.find(params[:id])
  end
end

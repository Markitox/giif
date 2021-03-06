class ProviderSessionsController < ApplicationController
  def create
    if authenticate?(params)
      session[:provider_id]
      redirect_to :files, :order_id => params[:order_id]
    else
      render :text => 'Unauthorized!'
    end
  end

  def destroy
    reset_session
    render :text => 'Good bye!'
  end

  private 
  def authenticate?(params)
    @order = Order.find(params[:order_id])
    @provider = Provider.find(params[:provider_id])
    if !(@order.nil? and @provider.nil?)
      return true if params[:token] == User.encrypt([@order.id, @provider.id, @provider.created_at.to_s].join('_')).slice(0..9)
    end  
    return false
  end


end

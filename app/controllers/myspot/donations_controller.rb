class Myspot::DonationsController < ApplicationController
  before_filter :login_required, :except => :create
  resources_controller_for :donations, :only => [:index, :create, :destroy]
  ssl_required :destroy

  response_for :index do |format|
    @credit_pitches = current_user.credit_pitches.paid
    update_balance_cookie
  end
  
  response_for :create do |format|
    logger.info @donation.errors.full_messages.to_sentence
    if resource_saved?
      update_balance_cookie
      session[:donation_id] = @donation.id # temporary solution for being able to retrieve donation for share popup
      if params[:spotus_lite].to_s == "true"
        format.html { redirect_to spotus_lite_myspot_donations_amounts_path }
      else
        format.html { redirect_to edit_myspot_donations_amounts_path }
      end
    else
      logger.error "ERROR: Problem creating donation"
      logger.error @donation.errors.full_messages.to_sentence
      format.html {
        flash[:error] = @donation.errors.full_messages.to_sentence
        redirect_to :back
      }
    end
  end

  response_for :destroy do |format|
    update_balance_cookie
    format.html { redirect_to edit_myspot_donations_amounts_path }
  end

  protected

  def can_create?
    if current_user.nil?
      session[:return_to] = edit_myspot_donations_amounts_path
      session[:news_item_id] = params[:pitch_id]
      session[:donation_amount] = params[:amount]
      render :partial => "sessions/header_form" and return false
    end

    access_denied unless Donation.createable_by?(current_user)
  end

  def new_resource
     current_user.donations.new(params[:donation])
     # TODO: figure out why donation_type does not get properly assigned with params / should not need to assign after new
     # d = Donation.new(params[:donation])
     # d.donation_type = params[:donation][:donation_type]
     # d
  end

  def find_resources
    current_user.donations.paid.paginate(:page => params[:page])
  end
end

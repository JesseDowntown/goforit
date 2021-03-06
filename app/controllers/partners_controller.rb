require 'rubygems'
require 'twilio-ruby'

class PartnersController < ApplicationController

	def index
		@partners = Partner.all
		@user = User.find(params[:user_id])
	end

	def show
		@partner = Partner.find(params[:id])
	end

	def new
		@partner = Partner.new
		@goals = Goal.all
		@user = User.find(params[:user_id])

	end

	def create
		@partner = Partner.new(partner_params)
		@partner.save
		partner_phone_number = @partner.phone_number
		twilio_send_text("Welcome to GoForIt! Thank you for being an accountability partner, #{@partner.first_name}.", partner_phone_number)
		if @partner.save
			redirect_to user_partners_path, :notice => "Partner created."
		else
			redirect_to user_partners_path, :notice => "Unable to create new partner."
		end
	end

	def edit
		@partner = Partner.find(params[:id])
		@goals = Goal.all
	end

	def update
		@partner = Partner.find(params[:id])
		@partner.update(partner_params)
		if @partner
		  redirect_to user_partners_path, :notice => "Partner updated."
		else
		  redirect_to user_partners_path, :alert => "Unable to update partner."
		end
	end

	def destroy
		@partner = Partner.find(params[:id])
		@partner.destroy
		redirect_to user_partners_path
	end

  def twilio_send_text(body, to)
  	account_sid = ENV['TWILIO_SID']  	
  	auth_token = ENV['TWILIO_TOKEN']
	  client = Twilio::REST::Client.new account_sid, auth_token

	  client.account.sms.messages.create(
	  	:body => body,
	  	:to => to,
	  	:from => "+15129611454")
	end

private
	def partner_params
		params.require(:partner).permit(:first_name, :last_name, :email_address, :phone_number, :goal_id, :frequency, :user_id)
	end
end
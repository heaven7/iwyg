class InvitationsController < InheritedResources::Base
  before_filter :authenticate_user!
	protect_from_forgery
  

	def index
		@invitations = current_user.invitations
	end

	def edit 
		@invitation = current_user.invitations.find(params[:id])
		@contacts = getContacts(@invitation)		
	end

	def contacts
		@contacts = getContacts(params)		
		params[:emails] if @contacts
	end

	def create
		@invitation = Invitation.new(params[:invitation])
		@invitation.sender = current_user
		create!
	end

	def show
		@invitation = current_user.invitations.find(params[:id])
	end

	private

	def getContacts(params)
		unless (params[:username].blank? or params[:password].blank?)
			username = params[:username]
			password =  params[:password]
			case params[:provider].to_s
			when "GMail"
				@contacts = Contacts.new(:gmail, username, password).contacts
		#	else
		#		@contacts = Contacts.guess(username, password).contacts
			end
			return @contacts
			
		end
	end
end

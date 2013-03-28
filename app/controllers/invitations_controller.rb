class InvitationsController < InheritedResources::Base
  before_filter :authenticate_user!
	protect_from_forgery
  

	def index
		@invitations = current_user.invitations
	end

	def edit 
		@invitation = current_user.invitations.find(params[:id])
	end

	def show
		@invitation = current_user.invitations.find(params[:id])
		@contacts = getContacts(@invitation)
	
		show!
	end

	private

	def getContacts(invitation)
		if (invitation.username and invitation.password)
			username = invitation.username
			password =  invitation.password
			case invitation.provider.to_s
			when "GMail"
				@contacts = Contacts.new(:gmail, username, password).contacts
		#	else
		#		@contacts = Contacts.guess(username, password).contacts
			end
			return @contacts
			
		end
	end
end

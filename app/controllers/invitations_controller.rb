class InvitationsController < InheritedResources::Base
  before_filter :authenticate_user!
	protect_from_forgery
  

	def index
		@invitations = current_user.invitations
	end

	def edit 
		@invitation = current_user.invitations.find(params[:id])
	end

	def contacts
		@contacts = getContacts(params)		
	end

	def create
		@invitation = Invitation.new(params[:invitation])
		@invitation.sender = current_user
		render :action => :sendInvitation
	end

	def show
		@invitation = current_user.invitations.find(params[:id])
	end

	def sendInvitation
		# create a friendship object of each recipient and
		# invoke InvitationsMailer to send message to each
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
			# make contact-list suitable for listbuilder
			@list = @contacts.map do |c|
				if c[1].blank?
					{ :label => c[0] }			
				else
					{ :label => c[0], :value => "#{c[0]}<#{c[1]}>" }
				end
			end
			return @list.to_json
			
		end
	end
end

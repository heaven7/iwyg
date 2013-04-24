class InvitationsController < InheritedResources::Base
  before_filter :authenticate_user!
	protect_from_forgery
  

	def index
		@invitations = current_user.invitations
	end

	def edit 
		@invitation = current_user.invitations.find(params[:id])
		@contacts_url = "#{request.url.gsub('edit','')}contacts"
	end

	def new
		@invitation = current_user.invitations.new()
		@contacts_url = "#{request.url}/contacts"
	end

	def contacts
		@contacts = getContacts(params)
	end

	def create
		@invitation = Invitation.new(params[:invitation])
		@invitation.sender = current_user
		if @invitation.save
			# create a friendship object of each recipient and
			# invoke InvitationsMailer to send message to each
			emails = @invitation.emails.split(",")
			emails.each do |email|
				@friend = friendsInvitation(email, @invitation)
				UserMailer.delay.sendInvitation(@invitation, @friend, signup_url(@friend.token))
			end
			render :action => :sendInvitation
		else 
			@contacts_url = "#{request.url}/new/contacts"
			render :action => :new		
		end
	end

	def show
		@invitation = current_user.invitations.find(params[:id])
	end

	def sendInvitation		
	end

	private

	def friendsInvitation(email, invitation)
		if (email.include? "<")
			email = email.gsub(/[<>]/, '<' => ',', '>' => '')
			parts = email.split(",")
			name = parts[0]
			email = parts[1]
		else
			name = email
		end
		f =	Friendship.new(
			:user => invitation.sender,
			:invitation => invitation,
			:name => name,
			:email => email
		)	
		f.generate_token
		f.save
		return f
	end

	def getContacts(params)
		unless (params[:username].blank? or params[:password].blank?)
			username = params[:username]
			password = params[:password]
			provider = params[:provider].to_s

			begin
				@contacts = Contacts.new(provider.to_sym, username, password).contacts
				flash[:notice] = "Contacts imported"		
				# make contact-list suitable for listbuilder
				@list = @contacts.map do |c|
					if c[1].blank?
						{ :label => c[0] }			
					else
						{ :label => c[0], :value => "#{c[0]}<#{c[1]}>" }
					end
				end
				return @list.to_json

			rescue => ex
				msg = ex.message		

				# check which kind of error appears				
				no_provider = ["valid"].any?{ |o| msg.include? o }
				wrong_credentials = ["password", "username"].any?{ |o| msg.include? o }	
				no_credentials = ["not", "blank"].any?{ |o| msg.include? o }
				if !no_provider.blank?
					flash[:error] = I18n.t("flash.invitations.chooseProvider")				
				elsif(!no_credentials.blank? or password.blank? or username.blank?)
					flash[:error] = I18n.t("flash.invitations.credentialsRequired")
				elsif !wrong_credentials.blank?
					flash[:error] = I18n.t("devise.failure.invalid").html_safe
				else
					flash[:error] = msg
				end

				return nil	
			end	

			
			
		end
	end
end

class InvitationsController < InheritedResources::Base
  before_filter :authenticate_user!

	def create
		getContacts
		create!
	end	
	
	def update
		getContacts
		update!
	end	

	private

	def getContacts
		if params[:username] and params[:password]
			@contacts = Contacts.guess(params[:username], params[:password]).contacts
			puts @contacts
		end
	end
end

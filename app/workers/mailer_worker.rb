class MailerWorker
	include Sidekiq::Worker

	def perform(mailerAction)
		mailerAction.deliver
	end

end

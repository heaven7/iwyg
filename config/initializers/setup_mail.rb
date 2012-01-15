if not Rails.env.empty?
  email_settings = YAML::load(File.open("#{Rails.root.to_s}/config/email.yml"))
  ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?
end

if Rails.env == 'test'
  ActionMailer::Base.default_url_options[:host] = "localhost:3000"
end
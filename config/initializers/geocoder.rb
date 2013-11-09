Geocoder.configure(
	:timeout  => 5,
	:lookup   => :google, # :bing, :freegeoip,
	:units    => :km,
	:language => :de
)
Rack::Request.send :include, Geocoder::Request

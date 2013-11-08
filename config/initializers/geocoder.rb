Geocoder.configure(
	:timeout  => 5,
	:lookup   => :yandex, #:google,
	:units    => :km,
	:language => :de
)
Rack::Request.send :include, Geocoder::Request

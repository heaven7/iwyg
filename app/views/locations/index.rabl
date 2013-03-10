collection @locations
attributes :id, :address, :lat, :lng, :locatable
child :locatable do
	attributes :login
end

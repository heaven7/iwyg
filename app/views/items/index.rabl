collection @items
attributes :id, :title, :description
child :images do
	attributes :id
end
child :events do
	attributes :from, :till
end
child :locations do
	attributes :address
end
child :tags do
	attributes :name
end

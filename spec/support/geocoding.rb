google_json = <<-JSON
{
  "status": "OK",
  "results": [ {
    "types": [ "street_address" ],
    "formatted_address": "Jakob-Kaiser-Str. 46, Nord Florentinedorf, Swasiland",
    "address_components": [ {
      "long_name": "45 Main Street, Long Road",
      "short_name": "45 Main Street, Long Road",
      "types": [ "route" ]
    }, {
      "long_name": "Nord Florentinedorf",
      "short_name": "Nord Florentinedorf",
      "types": [ "city", "political" ]
    }, {
      "long_name": "Swasiland",
      "types": [ "country", "political" ]
    } ],
    "geometry": {
      "location": {
        "lat": 62.579169021611,
        "lng": 80.505119743147
      }
    }
  } ]
}
JSON

FakeWeb.register_uri(:any, %r|http://maps\.googleapis\.com/maps/api/geocode|, :body => google_json)

import 'package:geocoder2/src/modal/data.dart';
import 'package:geocoder2/src/modal/fetch_geocoder.dart';
import 'package:http/http.dart' as http;

class Geocoder2 {
  ///Get City ,country , postalCode,state,streetNumber and countryCode from latitude and longitude
  static Future<GeoData> getDataFromCoordinates({
    required double latitude,
    required double longitude,
    required String googleMapApiKey,
    String? language,
  }) async {
    var url = language != null ? 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapApiKey&language=$language' : 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapApiKey';
    var request = http.Request('GET', Uri.parse(url));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      FetchGeocoder fetch = fetchGeocoderFromJson(data);
      String city = "";
      String country = "";
      String postalCode = "";
      String state = "";
      String streetNumber = "";
      String countryCode = "";
      String premise = "";
      String load = "";
      String regionGu = "";
      var addressComponent = fetch.results.first.addressComponents;
      for (var i = 0; i < addressComponent.length; i++) {
        if (addressComponent[i].types.contains("administrative_area_level_1")) {
          city = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("country")) {
          country = addressComponent[i].longName;
          countryCode = addressComponent[i].shortName;
        }
        if (addressComponent[i].types.contains("postal_code")) {
          postalCode = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("street_number")) {
          streetNumber = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("premise")) {
          premise = addressComponent[i].longName;
        }
        if(addressComponent[i].types.contains("sublocality_level_4")) {
          load = addressComponent[i].longName;
        }
        if(addressComponent[i].types.contains("sublocality_level_1")) {
          regionGu = addressComponent[i].longName;
        }
      }

      return GeoData(
        address: fetch.results.first.formattedAddress,
        city: city,
        country: country,
        latitude: latitude,
        longitude: longitude,
        postalCode: postalCode,
        state: state,
        streetNumber: streetNumber,
        countryCode: countryCode,
        premise: premise,
        load: load,
        regionGu: regionGu,
      );
    } else {
      return null as GeoData;
    }
  }

  ///Get City ,country , postalCode,state,streetNumber and countryCode from address like "277 Bedford Ave, Brooklyn, NY 11211, USA"
  static Future<GeoData> getDataFromAddress({
    required String address,
    required String googleMapApiKey,
    String? language,
  }) async {
    var url = language != null ? 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$googleMapApiKey&language=$language' : 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$googleMapApiKey';
    var request = http.Request('GET', Uri.parse(url));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      FetchGeocoder fetch = fetchGeocoderFromJson(data);
      String city = "";
      String country = "";
      String postalCode = "";
      String state = "";
      String streetNumber = "";
      String countryCode = "";

      var addressComponent = fetch.results.first.addressComponents;
      for (var i = 0; i < addressComponent.length; i++) {
        if (addressComponent[i].types.contains("administrative_area_level_2")) {
          city = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("country")) {
          country = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("country")) {
          countryCode = addressComponent[i].shortName;
        }
        if (addressComponent[i].types.contains("postal_code")) {
          postalCode = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("administrative_area_level_1")) {
          state = addressComponent[i].longName;
        }
        if (addressComponent[i].types.contains("street_number")) {
          streetNumber = addressComponent[i].longName;
        }
      }

      return GeoData(
        address: fetch.results.first.formattedAddress,
        city: city,
        country: country,
        latitude: fetch.results.first.geometry.location.lat,
        longitude: fetch.results.first.geometry.location.lng,
        postalCode: postalCode,
        state: state,
        countryCode: countryCode,
        streetNumber: streetNumber,
        premise: '',
        load: '',
        regionGu: '',
      );
    } else {
      return null as GeoData;
    }
  }
}

///Model class of the data.
class GeoData {
  GeoData({
    this.address,
    required this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.postalCode,
    this.state,
    this.countryCode,
    this.streetNumber,
    required this.premise,
    required this.load,
    required this.regionGu,
    

  });
  String? address;
  String city;
  String? country;
  double? latitude;
  double? longitude;
  String? postalCode;
  String? state;
  String? countryCode;
  String? streetNumber;
  String premise;
  String load;
  String regionGu;

}

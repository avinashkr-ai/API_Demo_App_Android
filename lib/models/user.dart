class Geo {
  final String lat;
  final String lng;

  const Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        lat: json['lat'] as String? ?? '',
        lng: json['lng'] as String? ?? '',
      );
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  const Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json['street'] as String? ?? '',
        suite: json['suite'] as String? ?? '',
        city: json['city'] as String? ?? '',
        zipcode: json['zipcode'] as String? ?? '',
        geo: Geo.fromJson(
          (json['geo'] as Map<String, dynamic>?) ?? const {},
        ),
      );

  String get formatted => '$suite $street, $city $zipcode';
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  const Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json['name'] as String? ?? '',
        catchPhrase: json['catchPhrase'] as String? ?? '',
        bs: json['bs'] as String? ?? '',
      );
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        username: json['username'] as String? ?? '',
        email: json['email'] as String? ?? '',
        address: Address.fromJson(
          (json['address'] as Map<String, dynamic>?) ?? const {},
        ),
        phone: json['phone'] as String? ?? '',
        website: json['website'] as String? ?? '',
        company: Company.fromJson(
          (json['company'] as Map<String, dynamic>?) ?? const {},
        ),
      );

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

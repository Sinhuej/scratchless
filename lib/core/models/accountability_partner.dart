class AccountabilityPartner {
  final String name;
  final String? phone;
  final String? email;

  const AccountabilityPartner({
    required this.name,
    this.phone,
    this.email,
  });

  factory AccountabilityPartner.empty() {
    return const AccountabilityPartner(
      name: '',
      phone: null,
      email: null,
    );
  }

  bool get hasName => name.trim().isNotEmpty;
  bool get hasPhone => phone != null && phone!.trim().isNotEmpty;
  bool get hasEmail => email != null && email!.trim().isNotEmpty;

  AccountabilityPartner copyWith({
    String? name,
    String? phone,
    String? email,
  }) {
    return AccountabilityPartner(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory AccountabilityPartner.fromJson(Map<String, dynamic> json) {
    return AccountabilityPartner(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }
}

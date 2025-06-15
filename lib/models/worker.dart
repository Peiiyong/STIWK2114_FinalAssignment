/*  
    Worker class is used to store and manage worker-related data.
*/
class Worker {
  String id;
  String fullName;
  String email;
  String phone;
  String address;

  Worker({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
  });

  // Parses data from a JSON object (e.g., from a database or API).
  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'].toString(),
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  // Converts the Worker object into JSON format so it can be saved or shared.
  // This allows other parts of the app (or users) to retrieve the data from the JSON file.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }
}

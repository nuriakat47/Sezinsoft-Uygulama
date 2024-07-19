class Customer {
  final String name;
  final String surname;
  final String orderNumber;
  final String orderDetails;

  Customer({required this.name, required this.surname, required this.orderNumber, required this.orderDetails});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'orderNumber': orderNumber,
      'orderDetails': orderDetails,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'],
      surname: map['surname'],
      orderNumber: map['orderNumber'],
      orderDetails: map['orderDetails'],
    );
  }
}

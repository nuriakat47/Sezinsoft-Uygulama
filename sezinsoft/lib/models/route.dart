import 'package:latlong2/latlong.dart';

class RouteModel {
  final String id;
  final String name;
  final LatLng startPoint;
  final LatLng endPoint;
  final String estimatedTime;
  final double distance;
  final List<Customer> customers;

  RouteModel({
    required this.id,
    required this.name,
    required this.startPoint,
    required this.endPoint,
    required this.estimatedTime,
    required this.distance,
    required this.customers,
  });
}

class Customer {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Customer({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

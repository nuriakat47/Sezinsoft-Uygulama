import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sezinsoft/models/route.dart';
import 'package:latlong2/latlong.dart';

final List<Customer> sampleCustomers = [
  Customer(id: '1', name: 'Müşteri', latitude: 38.7749, longitude: 30.4194),
];

final List<RouteModel> sampleRoutes = [
  RouteModel(
    id: '1',
    name: 'Rota 1',
    startPoint: LatLng(37.7749, -122.4194),
    endPoint: LatLng(37.8044, -122.2711),
    estimatedTime: '1h',
    distance: 10.0,
    customers: sampleCustomers,
  ),
];

final routesProvider =
    StateNotifierProvider<RoutesNotifier, List<RouteModel>>((ref) {
  return RoutesNotifier(sampleRoutes);
});

class RoutesNotifier extends StateNotifier<List<RouteModel>> {
  RoutesNotifier(List<RouteModel> initialRoutes) : super(initialRoutes);

  void addRoute(RouteModel route) {
    state = [...state, route];
  }

  void updateRoute(RouteModel updatedRoute) {
    state = state
        .map((route) => route.id == updatedRoute.id ? updatedRoute : route)
        .toList();
  }

  void removeRoute(String routeId) {
    state = state.where((route) => route.id != routeId).toList();
  }

  void addNewCustomerToRoute(
      String routeId, double latitude, double longitude) {
    state = state.map((route) {
      if (route.id == routeId) {
        final newCustomer = Customer(
          id: UniqueKey().toString(),
          name: 'Müşteri',
          latitude: latitude,
          longitude: longitude,
        );

        return RouteModel(
          id: route.id,
          name: route.name,
          startPoint: route.startPoint,
          endPoint: route.endPoint,
          estimatedTime: route.estimatedTime,
          distance: route.distance,
          customers: [...route.customers, newCustomer],
        );
      } else {
        return route;
      }
    }).toList();
  }
}

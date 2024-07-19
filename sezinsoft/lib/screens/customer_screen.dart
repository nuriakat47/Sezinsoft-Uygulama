import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sezinsoft/models/route.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sezinsoft/screens/route_selection_screen.dart';

import '../providers/route_provider.dart';
import 'detail_screen.dart';

class CustomerScreen extends StatelessWidget {
  final RouteModel route;
  final double distance;
  final double duration;

  const CustomerScreen({
    Key? key,
    required this.route,
    required this.distance,
    required this.duration,
  }) : super(key: key);

  void addNewCustomerWithCoordinates(double latitude, double longitude) {
    final RoutesNotifier routesNotifier =
    ProviderContainer().read(routesProvider.notifier);
    routesNotifier.addRoute(RouteModel(
      id: '2',
      name: 'Yeni Rota',
      startPoint: LatLng(latitude, longitude),
      endPoint: LatLng(latitude + 0.1, longitude + 0.1),
      estimatedTime: '1.5s',
      distance: 15.0,
      customers: [
        Customer(
          id: '2',
          name: 'Müşteri',
          latitude: latitude,
          longitude: longitude,
        )
      ],
    ));
  }

  void clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Müşteri Detayları',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Color.fromARGB(128, 0, 0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  'Müşteriler',
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: route.customers.length,
                  itemBuilder: (context, index) {
                    final customer = route.customers[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child:
                                Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(
                                customer.name,
                                style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.red),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Enlem: ${customer.latitude}, Boylam: ${customer.longitude}',
                                      style: GoogleFonts.roboto(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              trailing:
                              Icon(Icons.arrow_forward_ios, color: Colors.teal),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      routeName: route.name,
                                      distance: distance,
                                      duration: duration,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                clearSharedPreferences();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteSelectionScreen(),
                  ),
                ).then((_) {
                  addNewCustomerWithCoordinates(
                      40.0, 30.0);
                });
              },
              icon: Icon(Icons.add),
              label: Text('Müşteri Ekle', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

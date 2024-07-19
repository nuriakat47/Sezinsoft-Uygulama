import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:sezinsoft/models/route.dart';
import 'package:sezinsoft/screens/customer_screen.dart';

import '../widgedt/extra_map.dart';

class RouteDetailScreen extends ConsumerStatefulWidget {
  final LatLng destination;
  final RouteModel route;

  RouteDetailScreen({required this.destination, required this.route});

  @override
  _RouteDetailScreenState createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends ConsumerState<RouteDetailScreen> {
  List<LatLng> routePoints = [];
  LatLng? startPoint;
  bool isLoading = true;
  double distance = 0.0;
  double duration = 0.0;
  LatLng? selectedPoint; // Selected marker point

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      startPoint = LatLng(position.latitude, position.longitude);

      final osrmUrl =
          'http://router.project-osrm.org/route/v1/driving/${startPoint!.longitude},${startPoint!.latitude};${widget.destination.longitude},${widget.destination.latitude}?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(osrmUrl));
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          routePoints =
              (jsonResponse['routes'][0]['geometry']['coordinates'] as List)
                  .map((coords) => LatLng(coords[1], coords[0]))
                  .toList();
          distance =
              jsonResponse['routes'][0]['distance'] / 1000; // kilometreye çevir
          duration =
              jsonResponse['routes'][0]['duration'] / 60; // dakikaya çevir
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle exception
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        ],
      ),

      appBar: AppBar(
        title: Text(
          'Belirlenen Rota',
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: startPoint,
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        // Kullanıcı konumu
                        if (startPoint != null)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: startPoint!,
                            builder: (ctx) => Container(
                              child: Icon(FontAwesomeIcons.mapMarkerAlt,
                                  color: Colors.blue, size: 30),
                            ),
                          ),
                        // Müşteri konumu
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: widget.destination,
                          builder: (ctx) => Container(
                            child: Icon(FontAwesomeIcons.mapPin,
                                color: Colors.green, size: 30),
                          ),
                        ),

                      ],
                    ),
                    if (routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            strokeWidth: 4.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerScreen(
                                  route: widget.route,
                                  distance: distance,
                                  duration: duration,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          icon: Icon(Icons.person),
                          label: Text(
                            'Müşteri İşlemleri Yap',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Add some spacing between buttons
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InteractiveMap(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          icon: Icon(Icons.person),
                          label: Text(
                            'Not Ekle',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
    );
  }
}




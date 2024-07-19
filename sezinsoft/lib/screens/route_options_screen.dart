import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:sezinsoft/providers/route_provider.dart';
import 'package:sezinsoft/screens/route_detail_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class RouteOptionsScreen extends ConsumerWidget {
  final LatLng destination;

  RouteOptionsScreen({required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sampleRoutes = ref.watch(routesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rota Seçenekleri',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade800, Colors.teal.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: sampleRoutes.isEmpty
            ? Center(
          child: CircularProgressIndicator(),
        )
            : AnimationLimiter(
          child: ListView.builder(
            itemCount: sampleRoutes.length,
            itemBuilder: (context, index) {
              final route = sampleRoutes[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Card(
                      color: Colors.white.withAlpha(230),
                      elevation: 6,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(Icons.directions, color: Colors.white),
                        ),
                        title: Text(
                          route.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          ref.read(routesProvider.notifier).addNewCustomerToRoute(
                              route.id, destination.latitude, destination.longitude);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RouteDetailScreen(
                                  route: route, destination: destination),
                            ),
                          );
                        },
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NoteMarker {
  final String note;
  final LatLng point;

  NoteMarker(this.note, this.point);
}

class InteractiveMap extends StatefulWidget {
  @override
  _InteractiveMapState createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  List<NoteMarker> noteMarkers = [];
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Interactive Map',
          style: TextStyle(
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
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(38.4237, 27.1428),
          zoom: 13.0,
          onTap: (tapPosition, point) {
            _addNoteMarkerDialog(context, point);
          },
        ),
        mapController: mapController,
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: noteMarkers.map((marker) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: marker.point,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    _showNoteDialog(context, marker.note);
                  },
                  child: Container(
                    child: Icon(Icons.location_on, color: Colors.red, size: 30),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _addNoteMarkerDialog(BuildContext context, LatLng point) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        TextEditingController noteController = TextEditingController();

        return AlertDialog(
          title: Text('Noktaya Not Ekle'),
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(hintText: 'Notunuzu Girin'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ekle'),
              onPressed: () {
                setState(() {
                  noteMarkers.add(NoteMarker(noteController.text, point));
                });
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoteDialog(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text('Not'),
          content: Text(note),
          actions: <Widget>[
            TextButton(
              child: Text('Çık'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

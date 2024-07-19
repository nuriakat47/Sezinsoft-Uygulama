import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';
import 'message_screen.dart';

class DetailsScreen extends StatefulWidget {
  final String routeName;
  final double distance;
  final double duration;

  const DetailsScreen({
    required this.routeName,
    required this.distance,
    required this.duration,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customersJson = prefs.getString('customers');
    if (customersJson != null) {
      List<dynamic> customerMaps = jsonDecode(customersJson);
      setState(() {
        customers = customerMaps.map((map) => Customer.fromMap(map)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rota Detayları',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.map, color: Colors.teal, size: 30),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.routeName,
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.straighten, color: Colors.teal, size: 30),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Mesafe: ${widget.distance.toStringAsFixed(2)} km',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.timer, color: Colors.teal, size: 30),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Tahmini Zaman: ${widget.duration.toStringAsFixed(2)} dakika',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    customers.isEmpty
                        ? Center(
                            child: Text('Henüz müşteri bilgisi eklenmedi.'))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: customers.length,
                            itemBuilder: (context, index) {
                              Customer customer = customers[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          color: Colors.teal, size: 30),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'İsim: ${customer.name}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.person_outline,
                                          color: Colors.teal, size: 30),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Soyisim: ${customer.surname}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.confirmation_number,
                                          color: Colors.teal, size: 30),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Sipariş Numarası: ${customer.orderNumber}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.notes,
                                          color: Colors.teal, size: 30),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Sipariş Detayı: ${customer.orderDetails}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 20,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderFormScreen(),
                  ),
                ).then((_) {
                  _loadPreferences();
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Sipariş Ekle',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Mesaj Gönder',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderFormScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();
  final TextEditingController orderDetailsController = TextEditingController();

  _savePreferences(
      {required String name,
      required String surname,
      required String orderNumber,
      required String orderDetails}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? customersJson = prefs.getString('customers');
    List<Customer> customers = [];

    if (customersJson != null) {
      List<dynamic> customerMaps = jsonDecode(customersJson);
      customers = customerMaps.map((map) => Customer.fromMap(map)).toList();
    }

    Customer newCustomer = Customer(
        name: name,
        surname: surname,
        orderNumber: orderNumber,
        orderDetails: orderDetails);
    customers.add(newCustomer);

    await prefs.setString('customers',
        jsonEncode(customers.map((customer) => customer.toMap()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sipariş Formu',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'İsim',
                  labelStyle: GoogleFonts.roboto(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: 'Soyisim',
                  labelStyle: GoogleFonts.roboto(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: orderNumberController,
                decoration: InputDecoration(
                  labelText: 'Sipariş Numarası',
                  labelStyle: GoogleFonts.roboto(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: orderDetailsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Sipariş Detayı',
                  labelStyle: GoogleFonts.roboto(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _savePreferences(
                    name: nameController.text,
                    surname: surnameController.text,
                    orderNumber: orderNumberController.text,
                    orderDetails: orderDetailsController.text,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Kaydet',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

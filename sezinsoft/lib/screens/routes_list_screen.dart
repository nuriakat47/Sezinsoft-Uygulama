import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sezinsoft/providers/route_provider.dart';
import 'package:sezinsoft/screens/route_options_screen.dart';

class RoutesListScreen extends ConsumerWidget {
  get point => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ROTALAR'),
      ),
      body: routes.isEmpty
          ? Center(child: Text('Rota Bulunamadı!'))
          : ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return ListTile(
            title: Text(route.name),
            subtitle: Text('${route.startPoint} to ${route.endPoint}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteOptionsScreen(destination: point),
                ),
              );
            },

          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:photonic_browser/widgets.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';


class LocationBrowser extends StatefulWidget {
  const LocationBrowser({super.key});

  @override
  State<LocationBrowser> createState() => _LocationBrowserState();
}

class _LocationBrowserState extends State<LocationBrowser> {
  MapController mapController = MapController(
    location: LatLng.degree(18.2849695, -66.3490417),
    zoom: 9,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: MapView(
                mapController: mapController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MapView extends StatefulWidget {
  const MapView({
    super.key,
    required this.mapController,
  });
  final MapController mapController;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (scaleUpdate){
        double newZ = scaleUpdate.focalPointDelta.distance * 0.1;
        setState(() {
          widget.mapController.zoom -= newZ;
        });
      },
      child: MapLayout(
        controller: widget.mapController, 
        builder: (context,transformer){
          return TileLayer(
            builder: (context, x, y, z) {
              String url = "https://tile.openstreetmap.org/$z/$x/$y.png";
              return CachedNetworkImage(
                imageUrl: url,
              );
            },
          );
        },
      ),
    );
  }
}
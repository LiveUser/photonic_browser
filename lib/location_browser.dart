import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photonic_browser/widgets.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';


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
  double dragSensitivity = 0.01;
  double zoom = 0;
  @override
  void initState(){
    super.initState();
    zoom = widget.mapController.zoom;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Expanded(
          child: GestureDetector(
            onScaleUpdate: (details){
              // Handles dragging to pan
              double newLat = widget.mapController.center.latitude.degrees + details.focalPointDelta.dy * dragSensitivity / widget.mapController.zoom;
              double newLon = widget.mapController.center.longitude.degrees - details.focalPointDelta.dx * dragSensitivity / widget.mapController.zoom;
              widget.mapController.center = LatLng.degree(newLat, newLon);
              setState(() {
          
              });
            },
            child: Stack(
              children: [
                MapLayout(
                  controller: widget.mapController, 
                  builder: (context,transformer){
                    return TileLayer(
                      builder: (context, x, y, z) {            
                        String url = "https://tile.openstreetmap.org/$z/$x/$y.png";
                        return CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                ),
                Center(
                  child: Icon(
                    Icons.center_focus_weak,
                    color: Colors.deepPurple,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
        Slider(
          value: zoom, 
          min: 0,
          max: 19,
          onChanged: (newZoom){
            setState(() {
              zoom = newZoom;
              widget.mapController.zoom = newZoom;
            });
          },
        ),
      ],
    );
  }
}
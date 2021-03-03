import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_rekk/helpers/util.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:osm_nominatim/osm_nominatim.dart';

class LocationMaps extends StatefulWidget {
  @override
  _LocationMapsState createState() => _LocationMapsState();
}

double lattap = 15.127936526523328;
double lngtap = 120.60236373735461;

class _LocationMapsState extends State<LocationMaps> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getText() async {
    var reverseSearchResult = await Nominatim.reverseSearch(
      lat: lattap,
      lon: lngtap,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    );
    print('this is displayname');
    print(reverseSearchResult.displayName);
    // Location.location = reverseSearchResult.displayName;
    // print('this is address');
    // print(reverseSearchResult.address);
    // print('this is extratags');
    // print(reverseSearchResult.extraTags);
    // print('this is naedetails');
    // print(reverseSearchResult.nameDetails);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text("Location", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff1D976C),
      ),
      body: new FlutterMap(
        options: new MapOptions(
          onTap: (tapLoc) {
            print(tapLoc.latitude.toString() + tapLoc.longitude.toString());
            setState(() {
              lattap = tapLoc.latitude;
              lngtap = tapLoc.longitude;
              getText();
            });
          },
          center: latLng.LatLng(15.127936526523328, 120.60236373735461),
          zoom: 18.0,
        ),
        layers: [
          new TileLayerOptions(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                anchorPos: AnchorPos.align(AnchorAlign.center),
                point: new latLng.LatLng(lattap, lngtap),
                builder: (ctx) => new Container(
                  child: Icon(Icons.room, size: 50, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

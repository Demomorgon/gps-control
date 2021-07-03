import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:gps/firebase/firebase_db.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

String g = '';

class _InicioState extends State<Inicio> {
  DateTime now = DateTime.now();
  Firebase_db firebase_db = Firebase_db();
  bool sw = true;
  bool swubicacion = true;
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: () {
                  setState(() {
                    swubicacion = true;
                  });
                },
                icon: Icon(Icons.gps_fixed),
                label: Text('Ubicaciones')),
            TextButton.icon(
                onPressed: () {
                  setState(() {
                    swubicacion = false;
                  });
                },
                icon: Icon(Icons.directions_car),
                label: Text('Rutas'))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Gps prueva'),
        actions: [
          // Container(
          //   width: 50,
          //   child: SwitchListTile(
          //     title: Text(sw ? 'Satelital' : 'Normal'),
          //     value: sw,
          //     onChanged: (value) {
          //       setState(() {
          //         sw = value;
          //       });
          //     },
          //   ),
          // ),
          Container(
            alignment: Alignment.center,
            child: Text(
              sw ? 'Satelital' : 'Normal',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Switch(
            value: sw,
            onChanged: (value) {
              setState(() {
                sw = value;
              });
            },
          )
        ],
      ),
      body: getbody(),
    );
  }

  getbody() {
    return Column(
      children: [
        swubicacion
            ? SizedBox()
            : ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text('Fecha')),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: swubicacion
              ? firebase_db.ubicacion(id: '123456')
              : firebase_db.camino(id: '123456', dateTime: selectedDate),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
            if (data.hasData) {
              return swubicacion
                  ? _ubicaion(data.data!.docs)
                  : _camino(data.data!.docs);
            } else {
              return CircularProgressIndicator();
            }
          },
        ))
      ],
    );
  }

  _ubicaion(List<QueryDocumentSnapshot<Object?>> docs) {
    print('#########################');
    print(docs[0].get('id'));
    var ubicacion = LatLng(docs[0].get('lat'), docs[0].get('long'));
    return GoogleMap(
      mapType: sw ? MapType.hybrid : MapType.normal,
      initialCameraPosition: CameraPosition(
        target: ubicacion,
        zoom: 13,
      ),
      markers: _createMarkers(ubicacion),
    );
  }

  _camino(List<QueryDocumentSnapshot<Object?>> docs) {
    print('#########################');
    print(docs[0].get('id'));

    List<Map<String, dynamic>> ho = [];
    List<LatLng> point = [];
    Set<Polyline> newruta = Set();
    docs.forEach((element) {
      ho.add({
        'id': element.get('id'),
        'latlog': LatLng(element.get('lat'), element.get('long'))
      });
      point.add(LatLng(element.get('lat'), element.get('long')));
    });
    print(ho.first);
    print(ho.last);
    var line = Polyline(
        polylineId: PolylineId('MEJOR RUTA'),
        points: point,
        color: Colors.red,
        width: 4);
    newruta.add(line);
    return GoogleMap(
      mapType: sw ? MapType.hybrid : MapType.normal,
      initialCameraPosition: CameraPosition(
        target: ho.last['latlog'],
        zoom: 13,
      ),
      markers: _createMarkersCamino(ho.first['latlog'], ho.last['latlog']),
      polylines: newruta,
    );
  }

  Set<Marker> _createMarkers(LatLng ubicacion) {
    print('***************************************');
    print(ubicacion);
    var tmp = Set<Marker>();
    tmp.add(Marker(
        markerId: MarkerId('ubicacion'),
        position: ubicacion,
        icon: BitmapDescriptor.defaultMarker));
    return tmp;
  }

  Set<Marker> _createMarkersCamino(LatLng ubicacion, LatLng latLng) {
    var tmp = Set<Marker>();
    tmp.add(Marker(
        markerId: MarkerId('ubicacion inicial'),
        position: ubicacion,
        icon: BitmapDescriptor.defaultMarker));
    tmp.add(Marker(
      markerId: MarkerId('ubicaion final'),
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
    ));
    return tmp;
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}

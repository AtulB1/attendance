import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// class punchIn extends StatefulWidget {
//   const punchIn({super.key});

//   @override
//   State<punchIn> createState() => _punchInState();
// }

// class _punchInState extends State<punchIn> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       
//       body: Column(
//         children: [
//           Center(child: Text("succesuful login")),
//           ElevatedButton(onPressed: _signOut, child: Text("Logout"))
//         ],
//       ),
//     );
//   }
// }

// void _signOut() {
//   FirebaseAuth.instance.signOut();

//   runApp(new MaterialApp(
//     home: new LoginScreen(),
//   ));
// }

class punchIn extends StatefulWidget {
  @override
  _punchInState createState() => _punchInState();
}

class _punchInState extends State<punchIn> {
  late CameraController _controller;
  List<CameraDescription> cameras = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Location _location = Location();
  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
  }

  void _punchIn() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        LocationData locationData = await _location.getLocation();
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Punch In')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController!
                    .animateCamera(CameraUpdate.newLatLng(_currentLocation));
              },
              initialCameraPosition:
                  CameraPosition(target: _currentLocation, zoom: 15),
            ),
          ),
          Container(
            height: 200, 
            // child: CameraPreview(_controller),
          ),
          ElevatedButton(
            onPressed: _punchIn,
            child: Text('Punch In'),
          ),
        ],
      ),
    );
  }
}

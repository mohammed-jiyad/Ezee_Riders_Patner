import 'package:uig/features/emergency_contact/screens/emergency_contact.dart';
import 'package:uig/features/explore/screens/call_screen.dart';
import 'package:uig/features/explore/screens/enter_otp.dart';
import 'package:uig/features/explore/screens/explore.dart';
import 'package:uig/features/explore/screens/message_screen.dart';
import 'package:uig/features/explore/screens/ride_cancel.dart';
import 'package:uig/features/explore/widgets/time_line.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/features/online/widgets/help_widget.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:uig/Backend/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ArrivedTrip extends StatefulWidget {
  const ArrivedTrip({super.key});

  @override
  State<ArrivedTrip> createState() => _ArrivedTripState();
}

class _ArrivedTripState extends State<ArrivedTrip> {
  late GoogleMapController mapController;
  IO.Socket socket = SocketService().getSocket();
  String pickup = "";
  bool newmsg = false;
  String dropoff = "";
  double piclat = 0;
  double piclong = 0;
  double deslat = 0;
  double destlong = 0;
  String user = "";
  String? phno;
  String? objectid;
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Location location = Location();
  LatLng? userLocation;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polyLines = {};
  late LatLng sourceLocation;
  LatLng destinationLocation=LatLng(28.679079, 77.069710);
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    messages = [];
    getUserLocation();
    shared().then((_) {
      locafetchUser(objectid).then((_) {
        setState(() {
          sourceLocation = LatLng(piclat, piclong);
          destinationLocation = LatLng(deslat, destlong);

          _updatePolyline();
        });
        _initializeLocation();
      });
    });
    sendsocket();
  }

  Future<void> Insertdriver(String? id) async {
    final response = await http.post(
      Uri.parse('${server.link}/localAddFieldToUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'UserData': {'status': "cancelled"},
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['message']);
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to insert user');
    }
  }

  List<Message> messages = [];
  Future<void> sendsocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Handle connection event
    socket.on('connect', (_) {
      print('Connected to server');
    });
    socket.on('usercancelled', (data) async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ExploreScreen()));
    });
    socket.on('usermessage', (data) async {
      print("Received message: $data");
      print("message ${data['message']}");
      try {
        if (data != null && data is Map<String, dynamic>) {
          setState(() {
            messages.add(Message.fromJson(data['message']));
            newmsg = true;
          });
        } else {
          print("Invalid message format: $data");
        }
      } catch (e) {
        print("Error parsing message: $e");
      }
    });
    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  Future<void> shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      objectid = prefs.getString('ObjectId');
      phno = prefs.getString('UserPhno');
    });

    print('Printing the Object ID: $objectid');

    print('Phone Number is $phno');
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> locafetchUser(String? id) async {
    final response =
        await http.get(Uri.parse('${server.link}/locafindUser/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      pickup = data['currentAddress'];
      dropoff = data['destinationAddress'];
      piclat = data['currentLat'];
      piclong = data['currentLng'];
      deslat = data['destLat'];
      destlong = data['destLng'];
      user = data['userName'];
      print('Pickup: $pickup');
      print('Dropoff: $dropoff');
    } else if (response.statusCode == 404) {
      print('User not found');
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> _initializeLocation() async {
    // Get the current location immediately
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high);

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      _updateMarkers();
      _cameraToPosition(userLocation!);
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 14.0);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void _updateMarkers() {
    setState(() {
      markers = {
        Marker(markerId: const MarkerId("source"), position: sourceLocation),
        Marker(markerId: const MarkerId("user"), position: userLocation!),
        Marker(
            markerId: const MarkerId("destination"),
            position: destinationLocation),
      };
    });
  }

  void _updatePolyline() async {
    clearPolylines();
    final coordinates = await getPolylinePoints();
    generatePolylinefromPoints(coordinates);
  }

  void clearPolylines() {
    setState(() {
      polyLines.clear();
    });
  }

  void generatePolylinefromPoints(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polyLines[id] = polyline;
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: '${GOOGLE_API_KEY}',
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print("Polyline Error: ${result.errorMessage}");
    }
    return polylineCoordinates;
  }

  void _showDialogebox2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 207,
              child: Dialog(
                insetPadding: const EdgeInsets.only(
                  left: 17,
                  right: 17,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                backgroundColor: AppColors.backgroundColor,
                child: SizedBox(
                  height: ResponsiveSize.height(context, 249),
                  width: ResponsiveSize.width(context, 326),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ResponsiveSize.height(context, 32),
                      ),
                      Image.asset("assets/images/red.png"),
                      SizedBox(
                        height: ResponsiveSize.height(context, 20),
                      ),
                      Text(
                        "Call your emergency contact?",
                        style: AppTextStyles.headline3,
                      ),
                      SizedBox(
                        height: ResponsiveSize.height(context, 5),
                      ),
                      Text(
                        "Your location will be shared with your \nemergency contact along with it!",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.smalltitle,
                      ),
                      SizedBox(
                        height: ResponsiveSize.height(context, 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: ResponsiveSize.height(context, 42),
                            width: ResponsiveSize.width(context, 136),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: AppTextStyles.baseStyle2
                                    .copyWith(color: AppColors.newgreyColor),
                              ),
                            ),
                          ),
                          // 'Call' button
                          SizedBox(
                            height: ResponsiveSize.height(context, 42),
                            width: ResponsiveSize.width(context, 136),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.push(
                                  context, // Use the original context to navigate
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmergencyContact(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.call,
                                      color: AppColors.backgroundColor),
                                  SizedBox(
                                      width: ResponsiveSize.width(context, 4)),
                                  const Text(
                                    'Call',
                                    style: AppTextStyles.baseStyle2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  Future<void> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    String? latLngString = prefs.getString('userloc');
    if (latLngString != null) {
      List<String> latLngList = latLngString.split(',');
      double latitude = double.parse(latLngList[0]);
      double longitude = double.parse(latLngList[1]);
      userLocation = LatLng(latitude, longitude);
    } else {
      userLocation = null;
    }
    // Return null if no location is stored
  }

  void _showDialogebox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Positioned(
                top: 207,
                child: Dialog(
                  insetPadding: const EdgeInsets.only(left: 17, right: 17),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  backgroundColor: AppColors.backgroundColor,
                  child: SizedBox(
                    height: ResponsiveSize.height(context, 249),
                    width: ResponsiveSize.width(context, 326),
                    child: Column(
                      children: [
                        SizedBox(
                          height: ResponsiveSize.height(context, 32),
                        ),
                        Image.asset("assets/images/red.png"),
                        SizedBox(
                          height: ResponsiveSize.height(context, 10),
                        ),
                        Text("Do you wanna cancel pickup?",
                            style: AppTextStyles.headline3),
                        SizedBox(
                          height: ResponsiveSize.height(context, 5),
                        ),
                        Text(
                          "You cannot undo this action!",
                          style: AppTextStyles.smalltitle,
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, 5),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: " 9",
                              style: AppTextStyles.smalltitle
                                  .copyWith(color: AppColors.redColor)),
                          TextSpan(
                              text: "/10 cancellation left ",
                              style: AppTextStyles.smalltitle)
                        ])),
                        SizedBox(
                          height: ResponsiveSize.height(context, 40),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: ResponsiveSize.height(context, 42),
                              width: ResponsiveSize.width(context, 130),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: AppTextStyles.baseStyle2.copyWith(
                                        color: AppColors.newgreyColor),
                                  )),
                            ),
                            SizedBox(
                              height: ResponsiveSize.height(context, 42),
                              width: ResponsiveSize.width(context, 130),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.redColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? Object =
                                        prefs.getString('ObjectId');
                                    String? UserId =
                                        prefs.getString('UserSocket');
                                    socket.emit('CancelledDriver', {
                                      'driverId': socket.id,
                                      'userId': UserId
                                    });
                                    Insertdriver(Object);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 RideCancel()));
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: AppTextStyles.baseStyle2,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _showHelpPage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const HelpScreen();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            color: AppColors.backgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 12),
                vertical: ResponsiveSize.height(context, 12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 29),
                child: SizedBox(
                  width: ResponsiveSize.width(context, 360),
                  height: ResponsiveSize.height(context, 51),
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: ResponsiveSize.height(context, 19),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: ResponsiveSize.width(context, 2.5),
                                right: ResponsiveSize.width(context, 2.5),
                              ),
                              child: InkWell(
                                  onTap: () => _showHelpPage(context),
                                  child:
                                      const Icon(Icons.help_outline_rounded)),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveSize.height(context, 19),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: ResponsiveSize.width(context, 2.5),
                                right: ResponsiveSize.width(context, 2.5),
                              ),
                              child:
                                  const Icon(Icons.notifications_none_outlined),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveSize.height(context, 19),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: ResponsiveSize.width(context, 2.5),
                                right: ResponsiveSize.width(context, 2.5),
                              ),
                              child: const Icon(
                                Icons.warning_amber,
                                color: AppColors.redColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(children: [
          userLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  initialCameraPosition: CameraPosition(
                    target: userLocation!,
                    zoom: 14.0,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  markers: {
                    Marker(
                        markerId: const MarkerId("_destination"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: destinationLocation)
                  },
                  polylines: Set<Polyline>.of(polyLines.values),
                  mapType: MapType.normal),

          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveSize.height(context, 240),
              left: ResponsiveSize.width(context, 300),
            ),
            child: GestureDetector(
              onTap: () async {
                // Replace with your desired destination latitude and longitude
                // Example: Longitude

                // Google Maps URL
                final Uri googleMapsUrl = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&origin=${userLocation != null ? "${userLocation?.latitude},${userLocation?.longitude}" : "0,0"}&destination=$piclat,$piclong&travelmode=driving');

                // Open the URL externally
                if (await canLaunchUrl(googleMapsUrl)) {
                  await launchUrl(
                    googleMapsUrl,
                    mode:
                        LaunchMode.externalApplication, // Opens in external app
                  );
                } else {
                  throw 'Could not launch $googleMapsUrl';
                }
              },
              child: CircleAvatar(
                radius: 30, // Adjust size as needed
                backgroundImage: AssetImage('assets/navigation.png'),
                backgroundColor:
                    Colors.transparent, // Optional: Set background color
              ),
            ),
          ),

          // Iske baad apna UI daaldoHaa
          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveSize.height(context, 300),
            ),
            child: Container(
              height: ResponsiveSize.height(context, 444),
              width: ResponsiveSize.width(context, 360),
              color: AppColors.backgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: ListTile(
                      leading: Container(
                        height: ResponsiveSize.height(context, 36),
                        width: ResponsiveSize.width(context, 36),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purplebackground,
                        ),
                        child: IconButton(
                          icon: Center(
                            child: Icon(
                              Icons.phone,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          onPressed: () {
                            makePhoneCall(phno.toString());
                          },
                        ),
                      ),
                      title: const Padding(
                        padding: EdgeInsets.only(left: 60),
                        child: Text(
                          "0 min away",
                          style: AppTextStyles.baseStyle,
                        ),
                      ),
                      trailing: Stack(children: [
                        Container(
                          height: ResponsiveSize.height(context, 36),
                          width: ResponsiveSize.width(context, 36),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.purplebackground,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.message,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageScreen(
                                      initialMessages: List.from(
                                          messages)), // Pass a copy of messages
                                ),
                              ).then((_) {
                                // Clear the messages list after the screen is pushed
                                setState(() {
                                  messages.clear();
                                  newmsg=false;
                                });
                              });
                            },
                          ),
                        ),
                        if (newmsg == true)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: Colors.blue, // Blue dot color
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ]),
                    ),
                  ),
                  Container(
                    height: ResponsiveSize.height(context, 40),
                    width: ResponsiveSize.width(context, 278.56),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: SlideAction(
                      onSubmit: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EnterOtP()),
                        );
                      },
                      outerColor: AppColors.greenColor,
                      sliderButtonIcon: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Container(
                          height: ResponsiveSize.height(context, 30),
                          width: ResponsiveSize.width(context, 40),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.backgroundColor,
                          ),
                          child: const Icon(
                            Icons.two_wheeler,
                            size: 19,
                            color: AppColors.newgreenColor,
                          ),
                        ),
                      ),
                      sliderButtonIconPadding: 2,
                      text: "Arrived",
                      textStyle: AppTextStyles.smalltitle
                          .copyWith(color: AppColors.backgroundColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ResponsiveSize.height(context, 17)),
                    child: ListTile(
                      leading: Image.asset('assets/images/Ganesh.png'),
                      title: Text(
                        "$user",
                        style: AppTextStyles.baseStyle,
                      ),
                      trailing: Container(
                        height: ResponsiveSize.height(context, 17),
                        width: ResponsiveSize.height(context, 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.backgroundColor,
                          border: Border.all(color: AppColors.newgreyColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "4.4",
                              style: AppTextStyles.subtitle,
                            ),
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFD600),
                              size: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: SizedBox(
                      height: ResponsiveSize.height(context, 80),
                      child: TimeLinewidget(
                        isfirst: true,
                        islast: false,
                        isPast: true,
                        child: SizedBox(
                          height: ResponsiveSize.height(context, 70),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 8),
                              top: ResponsiveSize.height(context, 20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Pickup at",
                                          style: AppTextStyles.baseStyle
                                              .copyWith(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "$pickup",
                                  style: AppTextStyles.smalltitle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: TimeLinewidget(
                      isfirst: false,
                      islast: true,
                      isPast: false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "$dropoff",
                          style: AppTextStyles.baseStyle.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showDialogebox();
                    },
                    child: Text(
                      "Cancel ride",
                      style: AppTextStyles.headline3
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.height(context, 24),
                    ),
                    child: SizedBox(
                      width: ResponsiveSize.width(context, 327),
                      height: ResponsiveSize.height(context, 38),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          _showDialogebox2();
                        },
                        child: Text(
                          "SOS",
                          style: AppTextStyles.smalltitle
                              .copyWith(color: AppColors.backgroundColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}

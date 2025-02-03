
import 'package:uig/features/explore/screens/end_trip.dart';
import 'package:uig/features/explore/widgets/otp_form.dart';
import 'package:uig/features/explore/widgets/time_line.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'as geolocator;
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:uig/features/explore/screens/message_screen.dart';import 'dart:convert';
import 'package:uig/features/online/widgets/help_widget.dart';
import 'package:socket_io_client/socket_io_client.dart'as IO;
import 'package:http/http.dart'as http;
import 'package:uig/Backend/socket.dart';
class EnterOtP extends StatefulWidget {

  const EnterOtP({super.key});

  @override
  State<EnterOtP> createState() => _EnterOtPState();
}

class _EnterOtPState extends State<EnterOtP> {
  String validpin = '2345';
  String pickup="";
  IO.Socket socket=SocketService().getSocket();
  String dropoff="";
  double piclat=0;
  double piclong=0;
  double deslat=0;
  bool newmsg = false;
  double destlong=0;
  String? objectid;
  String? sockett;
  String user="";
  String? phno;
  bool? otpinfo=false;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  Location location = Location();
  LatLng? userLocation;
  bool isRideRequestAvailable = false;
  Map<String, dynamic> rideRequestData = {};
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polyLines = {};
  late LatLng sourceLocation;
  late LatLng destinationLocation;
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();

    loc();

  }
  void loc()async{

    await shared();
    await sendsocket();

    await locafetchUser(objectid);
     await _initializeLocation();
    await getUserLocation();
  }
  Future<void> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    String? latLngString = prefs.getString('userloc');
    if (latLngString != null) {
      List<String> latLngList = latLngString.split(',');
      double latitude = double.parse(latLngList[0]);
      double longitude = double.parse(latLngList[1]);
      userLocation=LatLng(latitude, longitude);
    }
    else{
      userLocation=null;
    }
    // Return null if no location is stored
  }
  Future<void> shared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    objectid=prefs.getString('ObjectId');
    prefs.setBool('verify', false);
    setState(() {
      otpinfo=prefs.getBool('verify');
      phno=prefs.getString('UserPhno');
      sockett=prefs.getString('UserSocket');
    });
    print('Printing the Object ID: $objectid');
    print('Phone Number is $phno');
  }
  void onOtpVerified(bool isVerified) {
    setState(() {
      otpinfo = isVerified;  // Update the otpinfo state when OTP is verified
    });
  }
  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }
  Future<void> locafetchUser(String? id) async {
    final response = await http.get(Uri.parse('${server.link}/locafindUser/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      pickup = data['currentAddress'];
      dropoff = data['destinationAddress'];
      piclat = data['currentLat'];
      piclong=data['currentLng'];
      deslat=data['destLat'];
      destlong=data['destLng'];
      user=data['userName'];
      print('Pickup: $pickup');
      print('Dropoff: $dropoff');
    } else if (response.statusCode == 404) {
      print('User not found');
    } else {
      throw Exception('Failed to fetch user data');
    }
    setState(() {
      sourceLocation = LatLng(piclat, piclong);
      destinationLocation = LatLng(deslat, destlong);
      _updatePolyline();
      print(destinationLocation);
    });
  }
  Future<void> _initializeLocation() async {
    bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // If location services are not enabled, ask to enable them
      serviceEnabled = await geolocator.Geolocator.requestPermission() == geolocator.LocationPermission.whileInUse;
      if (!serviceEnabled) return; // Exit if location service is still not enabled
    }

    // Check if permission is granted
    geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      // Request permission if not granted
      permission = await geolocator.Geolocator.requestPermission();
      if (permission != geolocator.LocationPermission.whileInUse && permission != geolocator.LocationPermission.always) {
        return; // Exit if permission is still denied
      }
    }

    // Get the current location immediately
    geolocator.Position position = await geolocator.Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);

    setState(() async{
      userLocation = LatLng(position.latitude, position.longitude);
       _updateMarkers();
      _cameraToPosition(userLocation!);
    });



  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 14.0);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  void _updateMarkers() {
    if (userLocation == null || sourceLocation == null || destinationLocation == null) {
      print('Markers cannot be updated as one or more locations are null.');
      return;
    }

    setState(() {
      markers = {
        Marker(markerId: MarkerId("source"), position: sourceLocation),
        Marker(markerId: MarkerId("user"), position: userLocation!),
        Marker(markerId: MarkerId("destination"), position: destinationLocation),
      };
    });

    print('Markers updated: $markers');
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
  Future<void> sendso()async{

      socket.emit('verified', {
        'userId': sockett
      });

  }
  bool variable=false;
  List<Message> messages = [];
  Future<void> sendsocket() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Handle connection event
    socket.on('connect', (_) {
      print('Connected to server');
    });
    socket.on('usermessage', (data) async {
      print("Received message: $data");
      print("message ${data['message']}");
      try {
        if (data != null && data is Map<String, dynamic>) {
          if (mounted) {
            setState(() {
              // Update your state only if the widget is still mounted
              newmsg = true;
              messages.add(Message.fromJson(data['message'])); // Add the received message
            });
          }
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
    PolylineId id = PolylineId('poly');
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
      googleApiKey: 'AIzaSyDnmIQv_9_UplZvWa63k1XcJCvLivkNC4s',
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("Polyline Error: ${result.errorMessage}");
    }
    return polylineCoordinates;
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
      resizeToAvoidBottomInset: true,
      appBar:    AppBar(
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
      body: Stack(
          children:[ userLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            onMapCreated: ((GoogleMapController controller )=> _mapController.complete(controller)),
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
            markers:
            {
              Marker(
                  markerId: MarkerId("_destination"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: destinationLocation
              )
            },
            polylines: Set<Polyline>.of(polyLines.values),
          ),Padding(
            padding: EdgeInsets.only(
              top: ResponsiveSize.height(context, 230),
              left: ResponsiveSize.width(context, 300),
            ),
            child: GestureDetector(
              onTap: () async {
                // Replace with your desired destination latitude and longitude
                // Example: Longitude

                // Google Maps URL
                final Uri googleMapsUrl = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&destination=$deslat,$destlong&travelmode=driving'
                );



                // Open the URL externally
                if (await canLaunchUrl(googleMapsUrl)) {
                  await launchUrl(
                    googleMapsUrl,
                    mode: LaunchMode.externalApplication, // Opens in external app
                  );
                } else {
                  throw 'Could not launch $googleMapsUrl';
                }
              },
              child: CircleAvatar(
                radius: 30, // Adjust size as needed
                backgroundImage: AssetImage('assets/navigation.png'),
                backgroundColor: Colors.transparent, // Optional: Set background color
              ),
            ),
          ),


            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveSize.height(context, 290),
                ),
                child: Container(
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 17),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: ResponsiveSize.height(context, 17)),
                          child: ListTile(
                            leading: Container(
                              height: ResponsiveSize.height(context, 36),
                              width: ResponsiveSize.width(context, 36),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.purplebackground,
                              ),
                              child: InkWell(
                                onTap: (){
                                  makePhoneCall(phno.toString());
                                },
                                child: const Icon(
                                  Icons.phone,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            title: Padding(
                              padding: EdgeInsets.only(
                                left: ResponsiveSize.width(context, 60),
                              ),
                              child: const Text(
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
                      otpinfo==true?
                        Container(
                          height: ResponsiveSize.height(context, 46),
                          width: ResponsiveSize.width(context, 278.56),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(ResponsiveSize.width(context, 28))),
                          child:
              
                          SlideAction(
                            onSubmit: () async {
                              await sendso();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const EndTrip()),
                              );
                            },
                            outerColor: AppColors.greenColor,
                            sliderButtonIcon: Padding(
                              padding: EdgeInsets.only(left: ResponsiveSize.width(context, 2)),
                              child: Container(
                                height: ResponsiveSize.height(context, 40),
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
                            text: "Start trip",
                            textStyle: AppTextStyles.smalltitle.copyWith(color: AppColors.backgroundColor),
                          ),
                        ):Container(),
                        Padding(
                          padding: EdgeInsets.only(top: ResponsiveSize.height(context, 17)),
                          child: ListTile(
                            leading: Image.asset('assets/images/Ganesh.png'),
                            title: Text(
                              "$user",
                              style: AppTextStyles.baseStyle,
                            ),
                            trailing: Container(
                              height: ResponsiveSize.height(context, 17),
                              width: ResponsiveSize.width(context, 40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ResponsiveSize.width(context, 12)),
                                color: AppColors.backgroundColor,
                              ),
                              child: Row(
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
                        SizedBox(height: ResponsiveSize.height(context, 10)),
                        Padding(
                          padding: EdgeInsets.only(left: ResponsiveSize.width(context, 10)),
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "OTP",
                              style: AppTextStyles.baseStyle,
                            ),
                          ),
                        ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [OtpForm(onVerified: onOtpVerified)],
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 10)),
                        TimeLinewidget(
                          isfirst: true,
                          islast: false,
                          isPast: true,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 8),
                              top: ResponsiveSize.height(context, 24),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Pickup at ",
                                    style: AppTextStyles.baseStyle.copyWith(fontSize: 16),
                                  ),
                                  TextSpan(
                                    text: "\n$pickup",
                                    style: AppTextStyles.smalltitle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TimeLinewidget(
                          isfirst: false,
                          islast: true,
                          isPast: false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveSize.width(context, 8),
                              bottom: ResponsiveSize.height(context, 5),
                            ),
                            child: Text(
                              "$dropoff",
                              style: AppTextStyles.baseStyle.copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              ),
            )
          ]
      ),
    );
  }
}
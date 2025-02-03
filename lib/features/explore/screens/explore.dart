import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:uig/features/online/widgets/help_widget.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uig/features/explore/screens/arrived_trip.dart';
import 'package:uig/features/explore/widgets/cancel.dart';
import 'package:uig/features/explore/widgets/time_line.dart';
import 'package:uig/features/payout/screens/payout.dart';
import 'package:uig/utils/app_colors.dart';
import 'package:uig/features/online/screens/online_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:uig/utils/app_text_styles.dart';
import 'package:uig/utils/responsive_size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:uig/utils/serverlink.dart';
import 'package:uig/Backend/socket.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late GoogleMapController mapController;
  IO.Socket socket=SocketService().getSocket();
  bool _isSwitched = false;
  Completer<GoogleMapController> _mapController = Completer();
  Location location = Location();
  LatLng? userLocation;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polyLines = {};
  bool isMapReady = true;  // Flag to track map initialization
  bool isRideRequestAvailable = false;
  int? otpgen;
  String? Drivername;
  String? Drivervehicle;
  String? DrivervehicleNumber;
  String? DrivervehicleType;
  String? phone_number;
  bool? val;
  Map<String, dynamic> rideRequestData = {};
  StreamSubscription<LocationData>? locationSubscription;
  static const LatLng _defaultLocation = LatLng(28.679079, 77.069710);

  @override
  void initState() {
    super.initState();

    wait();
  }
  void wait()async{


      initializeSocket().then((_) {
        print('Socket initialized');
        return _initializeLocation(); // Chain the next async operation
      }).then((_) {
        print('Location initialized');
        shared(); // Run synchronous/non-async logic
        _loadOnlineStatus(); // Run synchronous/non-async logic
        print('Shared executed and online status loaded');
      }).catchError((error) {
        print('Error during initialization: $error');
      }).whenComplete(() {
        print('Initialization process completed');
      });



  }
  @override
  void dispose() {
    locationSubscription?.cancel();
    socket.off('removeRideRequest');
    socket.off('newRideRequest');
    super.dispose();
  }
  Future<void> _setOnlineStatus(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnline', status);
    val=prefs.getBool('isOnline');
  }
  Future<void> _loadOnlineStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    val=prefs.getBool('isOnline');
    setState(() {
      if(val==true){
        _isSwitched = true;

      }
      else{
        _isSwitched = false;
      }


    });
    await initializeSocket();
    print(_isSwitched);
  }
  void shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Drivername = prefs.getString('DriverName');
      Drivervehicle = prefs.getString('VehicleCompany');
      print('Vehicle at EXPLORE $Drivervehicle');
      DrivervehicleNumber = prefs.getString('VehicleNumber');
      DrivervehicleType = prefs.getString('VehicleType');
      phone_number=prefs.getString('phone_number');
      print('PH NO at Explore $phone_number');
    });
    await SearchUser(phone_number.toString());
    setState(() {
      Drivername = prefs.getString('DriverName');
      Drivervehicle = prefs.getString('VehicleCompany');
      print('Vehicle at EXPLORE $Drivervehicle');
      DrivervehicleNumber = prefs.getString('VehicleNumber');
      DrivervehicleType = prefs.getString('VehicleType');
    });
  }
  List<dynamic> data=[];
  Future<void> SearchUser(String phno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = '${server.link}/searchUser/$phno';
    print('Logging URL');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('data found');
      setState(() {
        data = [json.decode(response.body)]; // Store the returned user object
      });
      print(data[0]['fullname']);
      print(data[0]['vehiclecompany']);
      print(data[0]['vehiclenumber']);
      print(data[0]['vehicletype']);
      prefs.setString('DriverName', data[0]['fullname']);
      prefs.setString('VehicleCompany', data[0]['vehiclecompany']);
      prefs.setString('VehicleNumber', data[0]['vehiclenumber']);
      prefs.setString('VehicleType', data[0]['vehicletype']);
    } else if (response.statusCode == 404) {
      print('No user found for the provided phone number');
      setState(() {
        data = []; // Empty list if no user is found
      });
    } else {
      throw Exception("Failed to load data");
    }
  }
  Future<void> initializeSocket() async {



    print('_iss $_isSwitched');

    if(_isSwitched==true) {
      if (!mounted) return;
      socket.on('removeRideRequest', (data) {
        setState(() {
          isRideRequestAvailable = false;
        });
      });

      socket.on('newRideRequest', (data) async {

        setState(() {
          isRideRequestAvailable = true;
          rideRequestData = data;

        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('ObjectId', data['objectid'].toString());
        await prefs.setString('UserName', data['userName']);
        print(data['totalFare']);
        await prefs.setDouble('Price', (data['totalFare'] is int) ? (data['totalFare'] as int).toDouble() : data['totalFare']);
        print(data['driverEarnings']);
        await prefs.setDouble('Drivermoney', (data['driverEarnings'] is int) ? (data['driverEarnings'] as int).toDouble() : data['driverEarnings']);
        print(data['userId']);
        await prefs.setString('UserSocket', data['userId']);
        print(data['userPhno']);
        await prefs.setString('UserPhno', data['userPhno']);
        print('Payment Mode ${data['paymentmode']}');
        await prefs.setString('PaymentMode', data['paymentmode']);
        print('Commission ${data['commission']}');
        await prefs.setDouble('Commission', (data['commission'] is int) ? (data['commission'] as int).toDouble() : data['commission']);
        FlutterRingtonePlayer().playNotification();

        // Vibrate the phone for a short period
        bool? hasVibrator = await Vibration.hasVibrator(); // Nullable value

        // Ensure that hasVibrator is not null and true before vibrating
        if (hasVibrator == true) {
          Vibration.vibrate(duration: 1000); // Vibrate for 1 second
        }


      });
    }
    else{
      socket.off('removeRideRequest');

      socket.off('newRideRequest');
    }



  }
  Future<void> iniloc()async{
    bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await geolocator.Geolocator.requestPermission() == geolocator.LocationPermission.whileInUse;
      if (!serviceEnabled) return;
    }

    geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission != geolocator.LocationPermission.whileInUse && permission != geolocator.LocationPermission.always) {
        return;
      }
    }
    print("Enters Location");

  }
  Future<void> _initializeLocation() async {
    await iniloc();
    geolocator.Position position = await geolocator.Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
      print(userLocation);
    });

    if (userLocation != null && isMapReady) {
      await _cameraToPosition(userLocation!);
    }
    print(socket.id);
    socket.emit('updateLocation', {
      'driverId': socket.id,
      'lat': position.latitude,
      'lon': position.longitude,
    });
    String latLngString = "${position.latitude},${position.longitude}";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userloc', latLngString);
  }

  Future<void> Insertdriver(String? id) async {
    final response = await http.post(
      Uri.parse('${server.link}/localAddFieldToUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'id': id,
        'UserData': {
          'driverName': Drivername,
          'Drivervehicle': Drivervehicle,
          'vehiclenumber': DrivervehicleNumber,
          'vehicletype': DrivervehicleType,
          'driverphno': phone_number
        },
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

  Future<void> _cameraToPosition(LatLng position) async {
    if (isMapReady) {
      final GoogleMapController controller = await _mapController.future;
      CameraPosition newCameraPosition = CameraPosition(target: position, zoom: 19.0);
      await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    } else {
      print("Map is not ready yet!");
    }
  }
  int myIndex = 0;
  Future<void> generateOtp() async {
    final random = Random();
    int otp = random.nextInt(9000) + 1000;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('OTP', otp);
    setState(() {
      otpgen = otp;
    });
  }
  void _onTapItem(int index) {
    setState(() {
      myIndex = index;
      print(index);

    });
    if(myIndex==3){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>PayOutScreen()));
    }
  }
  void _showHelpPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const HelpScreen();
      },
    );
  }

  Future<void> _showDialogebox(bool turningOn) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              content: SizedBox(
                height: ResponsiveSize.height(context, 197),
                width: ResponsiveSize.width(context, 340),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset(turningOn ? 'assets/images/green.png' : 'assets/images/red.png'),
                        SizedBox(height: ResponsiveSize.height(context, 5)),
                        Text(
                          turningOn ? 'Go Online again?' : 'Go Offline?',
                          style: turningOn ? AppTextStyles.headline2 : AppTextStyles.headline3,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 5)),
                    Text(
                      turningOn
                          ? 'After going online you will receive new ride requests'
                          : 'After going offline you will not receive new ride requests',
                      style: AppTextStyles.smalltitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 30)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: ResponsiveSize.height(context, 42),
                            width: ResponsiveSize.width(context, 100),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'No',
                                style: AppTextStyles.baseStyle2.copyWith(color: AppColors.newgreyColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveSize.height(context, 42),
                            width: ResponsiveSize.width(context, 100),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: turningOn ? AppColors.greenColor : AppColors.redColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () async {
                                // Perform async operation before calling setState

                                // Now update the state synchronously
                                setState(() {
                                  _isSwitched = turningOn;
                                });
                                print('valll $_isSwitched');
                                await initializeSocket();


                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Yes',
                                style: AppTextStyles.baseStyle2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  void acceptRide() async {
    await generateOtp();
    print(rideRequestData['userId']);
    socket.emit('acceptRide', {
      'name': Drivername,
      'car': Drivervehicle,
      'vehiclenumber': DrivervehicleNumber,
      'vehicletype': DrivervehicleType,
      'otp': otpgen,
      'userSocketId': rideRequestData['userId'],
      'driverId':socket.id
    });

    setState(() {
      isRideRequestAvailable = false;
      rideRequestData = {};
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? Object = prefs.getString('ObjectId');
    print(rideRequestData['driverEarnings']);

    print(Object);
    await Insertdriver(Object);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ArrivedTrip()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                            padding: EdgeInsets.only(left: ResponsiveSize.width(context, 2.5), right: ResponsiveSize.width(context, 2.5)),
                            child: InkWell(onTap: () => _showHelpPage(context), child: const Icon(Icons.help_outline_rounded)),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(left: ResponsiveSize.width(context, 2.5), right: ResponsiveSize.width(context, 2.5)),
                            child: const Icon(Icons.notifications_none_outlined),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, 19),
                          child: Padding(
                            padding: EdgeInsets.only(left: ResponsiveSize.width(context, 2.5), right: ResponsiveSize.width(context, 2.5)),
                            child: const Icon(
                              Icons.warning_amber,
                              color: AppColors.redColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    Flexible(
                      child: CupertinoListTile(
                        trailing: SizedBox(
                          width: ResponsiveSize.width(context, 48),
                          height: ResponsiveSize.height(context, 25),
                          child: CupertinoSwitch(
                            activeColor: AppColors.greenColor,
                            value: _isSwitched,
                            onChanged: (bool value) async{
                              await _showDialogebox(value);
                              if(_isSwitched==true){
                                _setOnlineStatus(true);
                                print('check $_isSwitched');
                              }
                              else{
                                _setOnlineStatus(false);
                                print('check $_isSwitched');
                              }

                            },
                          ),
                        ),
                        title: const Text(''),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
        body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SizedBox(

              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController.complete(controller);
                  setState(() {
                    isMapReady = true; // Set the map as ready
                 });
                },
                initialCameraPosition: CameraPosition(
                  target: _defaultLocation,
                  zoom: 18.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
              ),
            ),
            if (isRideRequestAvailable)
              Padding(
                padding: EdgeInsets.only(top: ResponsiveSize.height(context, 280)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.width(context, 12),
                    vertical: ResponsiveSize.height(context, 16),
                  ),
                  child: Container(
                    height: ResponsiveSize.height(context, 305),
                    width: ResponsiveSize.width(context, 326),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(ResponsiveSize.width(context, 12)),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 17,
                          spreadRadius: 12,
                          offset: Offset(0, 4),
                          color: AppColors.newShadowColor,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(ResponsiveSize.width(context, 16)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Online payment",
                                      style: AppTextStyles.baseStyle.copyWith(
                                        color: AppColors.greytextColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${rideRequestData['totalFare']}',
                                      style: AppTextStyles.baseStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              const CancelProgress(),
                            ],
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 16)),
                          Row(
                            children: [
                              Container(
                                height: ResponsiveSize.height(context, 24),
                                width: ResponsiveSize.width(context, 71),
                                decoration: BoxDecoration(
                                  color: AppColors.newBoxColor,
                                  borderRadius: BorderRadius.circular(ResponsiveSize.width(context, 18)),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/acute.jpg',
                                      height: ResponsiveSize.height(context, 16),
                                      width: ResponsiveSize.width(context, 16),
                                    ),
                                    SizedBox(width: ResponsiveSize.width(context, 5)),
                                    Text(
                                      "12 min",
                                      style: AppTextStyles.subtitle.copyWith(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: ResponsiveSize.height(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: ResponsiveSize.width(context, 8)),
                              Container(
                                height: ResponsiveSize.height(context, 24),
                                width: ResponsiveSize.width(context, 88),
                                decoration: BoxDecoration(
                                  color: AppColors.newBoxColor,
                                  borderRadius: BorderRadius.circular(ResponsiveSize.width(context, 18)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_sharp,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: ResponsiveSize.width(context, 5)),
                                    Text(
                                      "2Km away",
                                      style: AppTextStyles.subtitle.copyWith(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: ResponsiveSize.height(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 16)),
                          TimeLinewidget(
                            isfirst: true,
                            islast: false,
                            isPast: true,
                            child: Padding(
                              padding: EdgeInsets.only(left: ResponsiveSize.width(context, 8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pickup at 2km away",
                                    style: AppTextStyles.baseStyle.copyWith(
                                        fontSize: ResponsiveSize.height(context, 13.28)),
                                  ),
                                  SizedBox(height: ResponsiveSize.height(context, 1)),
                                  Text(
                                    "${rideRequestData['currentAddress']}",
                                    style: AppTextStyles.smalltitle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TimeLinewidget(
                            isfirst: false,
                            islast: true,
                            isPast: false,
                            child: Padding(
                              padding: EdgeInsets.only(left: ResponsiveSize.width(context, 8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Drop at 2km away",
                                    style: AppTextStyles.baseStyle.copyWith(
                                        fontSize: ResponsiveSize.height(context, 13.28)),
                                  ),
                                  SizedBox(height: ResponsiveSize.height(context, 1)),
                                  Text(
                                    "${rideRequestData['destinationAddress']}",
                                    style: AppTextStyles.smalltitle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: acceptRide,
                            child: Container(
                              alignment: Alignment.center,
                              height: ResponsiveSize.height(context, 48),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(ResponsiveSize.width(context, 12)),
                              ),
                              child: Text(
                                "Accept",
                                style: AppTextStyles.baseStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        ),
          //bottomNavigationBar: Container(
    //color: AppColors.backgroundColor,
    //width: ResponsiveSize.width(context, 360),
    //height: ResponsiveSize.height(context, 97),
    //child: BottomNavigationBar(
    //onTap: _onTapItem,
    //currentIndex: myIndex,
    //selectedItemColor: AppColors.primaryColor,
    //unselectedItemColor: AppColors.greytextColor,
    //unselectedLabelStyle: AppTextStyles.subtitle.copyWith(fontSize: 8),
    //selectedLabelStyle: AppTextStyles.subtitle
      //  .copyWith(fontSize: 10.5, color: AppColors.primaryColor),
    //items: const [
    //BottomNavigationBarItem(
    //backgroundColor: AppColors.backgroundColor,
    //icon: Icon(Icons.explore),
    //label: 'Explore'),
    ////BottomNavigationBarItem(
    //backgroundColor: AppColors.backgroundColor,
    //icon: Icon(Icons.two_wheeler_outlined),
    //label: 'Trips'),
    //BottomNavigationBarItem(
    //backgroundColor: AppColors.backgroundColor,
    //icon: Icon(Icons.currency_rupee_rounded),
    //label: 'Earning',),
    //BottomNavigationBarItem(
   // backgroundColor: AppColors.backgroundColor,
    //icon: Icon(Icons.account_balance_wallet),
   // label: 'Payout'),

    //BottomNavigationBarItem(
   // backgroundColor: AppColors.backgroundColor,
    //icon: Icon(Icons.menu),
    //label: 'More',
   // )
   // ]),
   // ),
    );
  }
}

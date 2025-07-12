import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fusion Cards',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MerchantMapScreen(),
    );
  }
}

class Merchant {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String category;
  final double rating;
  final String? phoneNumber;
  final bool isOpenNow;
  final String? photoReference;
  double? distance;

  Merchant({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.rating,
    this.phoneNumber,
    this.isOpenNow = false,
    this.photoReference,
    this.distance,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['place_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      address: json['vicinity'] ?? json['formatted_address'] ?? '',
      latitude: json['geometry']['location']['lat']?.toDouble() ?? 0.0,
      longitude: json['geometry']['location']['lng']?.toDouble() ?? 0.0,
      category: json['types']?.first ?? 'establishment',
      rating: json['rating']?.toDouble() ?? 0.0,
      phoneNumber: json['formatted_phone_number'],
      isOpenNow: json['opening_hours']?['open_now'] ?? false,
      photoReference: json['photos']?[0]?['photo_reference'],
    );
  }
}

class LocationService {
  static Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}

class MerchantService {
  static const String API_KEY = 'YOUR_GOOGLE_PLACES_API_KEY';

  static Future<List<Merchant>> getNearbyMerchants(
      double latitude, double longitude,
      {int radius = 1500}) async {
    if (API_KEY == 'YOUR_GOOGLE_PLACES_API_KEY') {
      // Return mock data if API key is not set
      return getMockMerchants(latitude, longitude);
    }

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$latitude,$longitude'
          '&radius=$radius'
          '&type=establishment'
          '&key=$API_KEY';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        List<Merchant> merchants = results
            .map((result) => Merchant.fromJson(result))
            .where((merchant) =>
                merchant.rating > 0) // Filter out places without ratings
            .toList();

        for (var merchant in merchants) {
          merchant.distance = Geolocator.distanceBetween(
            latitude,
            longitude,
            merchant.latitude,
            merchant.longitude,
          );
        }

        // Sort by distance
        merchants.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

        return merchants.take(20).toList(); // Limit to 20 merchants
      } else {
        throw Exception('Failed to load merchants: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching merchants: $e');
      // Return mock data as fallback
      return getMockMerchants(latitude, longitude);
    }
  }

  static List<Merchant> getMockMerchants(double userLat, double userLng) {
    return [
      Merchant(
        id: '1',
        name: 'Starbucks Coffee',
        address: 'Near your location',
        latitude: userLat + 0.002,
        longitude: userLng + 0.001,
        category: 'cafe',
        rating: 4.5,
        isOpenNow: true,
      ),
      Merchant(
        id: '2',
        name: 'Reliance Digital',
        address: 'Electronics Store',
        latitude: userLat + 0.004,
        longitude: userLng - 0.002,
        category: 'electronics_store',
        rating: 4.2,
        isOpenNow: true,
      ),
      Merchant(
        id: '3',
        name: 'Local Supermarket',
        address: 'Grocery Store',
        latitude: userLat - 0.003,
        longitude: userLng + 0.003,
        category: 'grocery_or_supermarket',
        rating: 4.0,
        isOpenNow: true,
      ),
      Merchant(
        id: '4',
        name: 'McDonald\'s',
        address: 'Fast Food Restaurant',
        latitude: userLat + 0.001,
        longitude: userLng - 0.001,
        category: 'restaurant',
        rating: 4.3,
        isOpenNow: true,
      ),
      Merchant(
        id: '5',
        name: 'Local Pharmacy',
        address: 'Medical Store',
        latitude: userLat - 0.002,
        longitude: userLng - 0.002,
        category: 'pharmacy',
        rating: 4.1,
        isOpenNow: false,
      ),
    ];
  }
}

class MerchantMapScreen extends StatefulWidget {
  @override
  _MerchantMapScreenState createState() => _MerchantMapScreenState();
}

class _MerchantMapScreenState extends State<MerchantMapScreen>
    with AutomaticKeepAliveClientMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<Merchant> _merchants = [];
  Set<Marker> _markers = {};
  bool _isLoading = false;
  String _errorMessage = '';
  bool _mapLoaded = false;
  bool _disposed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  Future<void> _initializeMap() async {
    if (_disposed) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final position = await LocationService.getCurrentLocation();

      if (!_disposed && position != null) {
        setState(() {
          _currentPosition = position;
        });
        await _loadMerchants();
      } else if (!_disposed) {
        setState(() {
          _errorMessage =
              'Unable to get current location. Please enable location services and grant permission.';
        });
      }
    } catch (e) {
      if (!_disposed) {
        setState(() {
          _errorMessage = 'Error: $e';
        });
      }
    } finally {
      if (!_disposed) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMerchants() async {
    if (_currentPosition == null || _disposed) return;

    try {
      final merchants = await MerchantService.getNearbyMerchants(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (!_disposed) {
        setState(() {
          _merchants = merchants;
        });

        _createMarkers();
      }
    } catch (e) {
      if (!_disposed) {
        setState(() {
          _errorMessage = 'Error loading merchants: $e';
        });
      }
    }
  }

  void _createMarkers() {
    if (_disposed) return;

    Set<Marker> markers = {};

    // Add user location marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: MarkerId('user_location'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'You are here',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add merchant markers
    for (var merchant in _merchants) {
      markers.add(
        Marker(
          markerId: MarkerId(merchant.id),
          position: LatLng(merchant.latitude, merchant.longitude),
          infoWindow: InfoWindow(
            title: merchant.name,
            snippet:
                '${merchant.address}\n⭐ ${merchant.rating} • ${_formatDistance(merchant.distance ?? 0)}',
          ),
          icon: _getMarkerIcon(merchant.category),
          onTap: () => _showMerchantDetails(merchant),
        ),
      );
    }

    if (!_disposed) {
      setState(() {
        _markers = markers;
      });
    }
  }

  BitmapDescriptor _getMarkerIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cafe':
      case 'coffee_shop':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case 'restaurant':
      case 'food':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'electronics_store':
      case 'store':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet);
      case 'grocery_or_supermarket':
      case 'supermarket':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'pharmacy':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      case 'gas_station':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
    }
  }

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    if (_disposed) return;

    _mapController = controller;
    setState(() {
      _mapLoaded = true;
    });

    // Move camera to user location
    if (_currentPosition != null) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (!_disposed && _mapController != null) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              15.0,
            ),
          );
        }
      });
    }
  }

  void _showMerchantDetails(Merchant merchant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Merchant info
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(merchant.category),
                      color: Colors.blue,
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            merchant.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            merchant.address,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Rating, distance, and open status
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 5),
                    Text('${merchant.rating}', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 20),
                    Icon(Icons.location_on, color: Colors.red, size: 20),
                    SizedBox(width: 5),
                    Text(
                      _formatDistance(merchant.distance ?? 0),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: merchant.isOpenNow ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        merchant.isOpenNow ? 'Open' : 'Closed',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Category
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    merchant.category.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                if (merchant.phoneNumber != null) ...[
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text(
                        merchant.phoneNumber!,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],

                Spacer(),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _navigateToMerchant(merchant);
                        },
                        icon: Icon(Icons.directions),
                        label: Text('Directions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _centerMapOnMerchant(merchant);
                        },
                        icon: Icon(Icons.center_focus_strong),
                        label: Text('Center Map'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _centerMapOnMerchant(Merchant merchant) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(merchant.latitude, merchant.longitude),
        17.0,
      ),
    );
  }

  void _navigateToMerchant(Merchant merchant) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions to ${merchant.name}'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cafe':
      case 'coffee_shop':
        return Icons.coffee;
      case 'restaurant':
      case 'food':
        return Icons.restaurant;
      case 'electronics_store':
      case 'store':
        return Icons.devices;
      case 'grocery_or_supermarket':
      case 'supermarket':
        return Icons.shopping_cart;
      case 'gas_station':
        return Icons.local_gas_station;
      case 'pharmacy':
        return Icons.local_pharmacy;
      default:
        return Icons.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Merchants'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _currentPosition != null ? _goToUserLocation : null,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _initializeMap,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          if (_currentPosition != null && !_isLoading)
            GoogleMap(
              key: ValueKey(
                  'map_${_currentPosition!.latitude}_${_currentPosition!.longitude}'),
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 15.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              gestureRecognizers: Set()
                ..add(
                    Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                ..add(Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer()))
                ..add(
                    Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer())),
            ),

          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Getting your location...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Error message
          if (_errorMessage.isNotEmpty && !_isLoading)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location Error',
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _initializeMap,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Merchant count
          if (_merchants.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    '${_merchants.length} merchants nearby',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),

          // No location permission message
          if (_currentPosition == null &&
              !_isLoading &&
              _errorMessage.isNotEmpty)
            Center(
              child: Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_off, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Location Required',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please enable location services and grant permission to find nearby merchants.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializeMap,
                        child: Text('Enable Location'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _goToUserLocation() {
    if (_currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          16.0,
        ),
      );
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }
}

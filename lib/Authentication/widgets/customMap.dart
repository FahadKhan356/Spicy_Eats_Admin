import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

/// Change the Map Tiles for OSM
enum MapType { normal, satelite }

/// Location Result contains:
/// * [latitude] as [double]
/// * [longitude] as [double]
/// * [completeAddress] as [String]
/// * [placemark] as [Placemark]
class LocationResult {
  /// the latitude of the picked location
  double? latitude;

  /// the longitude of the picked location
  double? longitude;

  /// the complete address of the picked location
  String? completeAddress;

  /// the location name of the picked location
  String? locationName;

  /// the placemark infomation of the picked location
  Placemark? placemark;

  LocationResult(
      {required this.latitude,
      required this.longitude,
      required this.completeAddress,
      required this.placemark,
      required this.locationName});
}

class CustomMap extends StatefulWidget {
  /// The initial longitude
  final double? initialLongitude;

  /// The initial latitude
  final double? initialLatitude;

  /// callback when location is picked
  final Function(LocationResult onPicked) onPicked;
  final Color? backgroundColor;

  /// The setLocaleIdentifier with the localeIdentifier parameter can be used to enforce the results to be formatted (and translated) according to the specified locale. The localeIdentifier should be formatted using the syntax: [languageCode]_[countryCode]. Use the ISO 639-1 or ISO 639-2 standard for the language code and the 2 letter ISO 3166-1 standard for the country code.
  final String? locale;

  final Color? indicatorColor;
  final Color? sideButtonsColor;
  final Color? sideButtonsIconColor;

  final TextStyle? locationNameTextStyle;
  final TextStyle? addressTextStyle;
  final TextStyle? searchTextStyle;
  final TextStyle? buttonTextStyle;
  final Widget? centerWidget;
  final double? initialZoom;
  final Color? buttonColor;
  final String? buttonText;
  final Widget? leadingIcon;
  final InputDecoration? searchBarDecoration;
  final bool myLocationButtonEnabled;
  final bool zoomButtonEnabled;
  final bool searchBarEnabled;
  final bool switchMapTypeEnabled;
  final MapType? mapType;
  final Widget Function(LocationResult locationResult)? customButton;
  final Widget Function(
      LocationResult locationResult, MapController mapController)? customFooter;
  final Widget Function(
      LocationResult locationResult, MapController mapController)? sideWidget;

  /// [onPicked] action on click select Location
  /// [initialLatitude] the latitude of the initial location
  /// [initialLongitude] the longitude of the initial location
  const CustomMap(
      {super.key,
      required this.initialLatitude,
      required this.initialLongitude,
      required this.onPicked,
      this.backgroundColor,
      this.indicatorColor,
      this.addressTextStyle,
      this.searchTextStyle,
      this.centerWidget,
      this.buttonColor,
      this.buttonText,
      this.leadingIcon,
      this.searchBarDecoration,
      this.myLocationButtonEnabled = true,
      this.searchBarEnabled = true,
      this.sideWidget,
      this.customButton,
      this.customFooter,
      this.buttonTextStyle,
      this.zoomButtonEnabled = true,
      this.initialZoom,
      this.switchMapTypeEnabled = true,
      this.mapType,
      this.sideButtonsColor,
      this.sideButtonsIconColor,
      this.locationNameTextStyle,
      this.locale});

  State<StatefulWidget> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<CustomMap> {
  bool _error = false;
  bool _move = false;
  Timer? _timer;
  final MapController _controller = MapController();
  final List<Location> _locationList = [];
  List<LocationResult> _locationlistWeb = [];
  MapType _mapType = MapType.normal;

  LocationResult? _locationResult;

  double _latitude = -6.984072660841485;
  double _longitude = 110.40950678599624;
  String _completeaddress = '';

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLatitude ?? -6.984072660841485;
    _longitude = widget.initialLongitude ?? 110.40950678599624;

    if (widget.mapType != null) {
      _mapType = widget.mapType!;
    }
    _setupInitalLocation();
  }

  _setupInitalLocation() async {
    if (widget.locale != null) {
      await setLocaleIdentifier(widget.locale!);
    }
    _locationResult = LocationResult(
        latitude: _latitude,
        longitude: _longitude,
        completeAddress: null,
        locationName: null,
        placemark: null);
    _getLocationResult();
  }

  _getLocationResult() async {
    _locationResult =
        await getLocationResult(latitude: _latitude, longitude: _longitude);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar() {
      return widget.searchBarEnabled
          ? Column(
              children: [
                Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black45,
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(1, 1)),
                  ]),
                  child: TextField(
                    style: widget.searchTextStyle,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        if (!kIsWeb) {
                          _error = false;
                          setState(() {});
                          try {
                            _locationList.clear();
                            _locationList
                                .addAll(await locationFromAddress(value));

                            if (_locationList.isNotEmpty) {
                            } else {
                              _error = true;
                            }
                          } catch (e) {
                            _error = true;
                          }
                          setState(() {});
                        } else {
                          if (value.isNotEmpty) {
                            _error = false;
                            setState(() {});
                            try {
                              _locationList.clear();

                              final url =
                                  'https://nominatim.openstreetmap.org/search?q=$value&format=json&limit=5';
                              final response =
                                  await http.get(Uri.parse(url), headers: {
                                'User-Agent':
                                    'FlutterApp (fahadk8080@email.com)',
                              });

                              if (response.statusCode == 200) {
                                final data = jsonDecode(response.body);

                                if (data != null && data.isNotEmpty) {
                                  for (var item in data) {
                                    print(
                                        "displayname ${item['display_name']}");
                                    final lat =
                                        double.tryParse(item['lat'] ?? '');
                                    final lon =
                                        double.tryParse(item['lon'] ?? '');
                                    final displayName =
                                        item['display_name'] ?? '';

                                    if (lat != null && lon != null) {
                                      print("displayname $displayName");
                                      _locationlistWeb.add(LocationResult(
                                          latitude: lat,
                                          longitude: lon,
                                          completeAddress: displayName,
                                          placemark: null,
                                          locationName: null));
                                    }
                                  }
                                } else {
                                  _error = true;
                                }
                              } else {
                                _error = true;
                              }
                            } catch (e) {
                              print("Search error: $e");
                              _error = true;
                            }
                            setState(() {});
                          } else {
                            _locationList.clear();
                            _error = false;
                            setState(() {});
                          }
                        }
                      } else {
                        _locationList.clear();
                        _error = false;
                        setState(() {});
                      }
                    },
                    decoration: widget.searchBarDecoration ??
                        InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: widget.indicatorColor,
                          ),
                          fillColor: widget.backgroundColor ?? Colors.white,
                          filled: true,
                        ),
                  ),
                ),
                kIsWeb
                    ? _locationlistWeb.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              final item = _locationlistWeb[index];
                              return ListTile(
                                title: Text(item.completeAddress!),
                                onTap: () {
                                  _move = true;
                                  _latitude = item.latitude!;
                                  _longitude = item.longitude!;

                                  _controller.move(
                                    LatLng(_latitude, _longitude),
                                    16,
                                  );

                                  _locationResult = item;
                                  _locationlistWeb.clear();
                                  setState(() {});
                                },
                              );
                            },
                            itemCount: _locationlistWeb.length,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                          )
                        : Container()
                    : _locationList.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return LocationItem(
                                data: _locationList[index],
                                backgroundColor: widget.backgroundColor,
                                locationNameTextStyle:
                                    widget.locationNameTextStyle,
                                addressTextStyle: widget.addressTextStyle,
                                onResultClicked: (LocationResult result) {
                                  _move = true;
                                  _latitude = result.latitude ?? 0;
                                  _longitude = result.longitude ?? 0;
                                  _controller.move(
                                      LatLng(result.latitude ?? 0,
                                          result.longitude ?? 0),
                                      16);
                                  _locationResult = result;
                                  _locationList.clear();
                                  setState(() {});
                                },
                              );
                            },
                            itemCount: _locationList.length,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                          )
                        : Container(),
                _error
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: widget.backgroundColor ?? Colors.white,
                        child: Text(
                          "Location not found",
                          style: widget.searchTextStyle,
                        ),
                      )
                    : Container()
              ],
            )
          : Container();
    }

    Widget viewLocationName() {
      return widget.customFooter != null
          ? widget.customFooter!(
              _locationResult ??
                  LocationResult(
                      latitude: _latitude,
                      longitude: _longitude,
                      completeAddress: null,
                      placemark: null,
                      locationName: null),
              _controller)
          : Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: widget.backgroundColor ?? Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      widget.leadingIcon ??
                          Icon(
                            Icons.location_city,
                            color: widget.indicatorColor,
                          ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _locationResult?.completeAddress ??
                                "Location not found",
                            style: widget.locationNameTextStyle ??
                                Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            _locationResult?.completeAddress ?? "-",
                            style: widget.addressTextStyle ??
                                Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.customButton != null
                      ? widget.customButton!(_locationResult ??
                          LocationResult(
                              latitude: _latitude,
                              longitude: _longitude,
                              completeAddress: null,
                              placemark: null,
                              locationName: null))
                      : SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onPicked(_locationResult ??
                                  LocationResult(
                                      latitude: _latitude,
                                      longitude: _longitude,
                                      completeAddress: null,
                                      placemark: null,
                                      locationName: null));
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.black87),
                            child: Text(
                              widget.buttonText != null
                                  ? widget.buttonText!
                                  : "Select Location",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                ],
              ),
            );
    }

    Widget sideButton() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: widget.switchMapTypeEnabled,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: () {
                  if (_mapType == MapType.normal) {
                    _mapType = MapType.satelite;
                  } else {
                    _mapType = MapType.normal;
                  }
                  setState(() {});
                },
                style: TextButton.styleFrom(
                    backgroundColor: widget.sideButtonsColor ?? Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10)),
                child: Icon(Icons.layers,
                    color: widget.sideButtonsIconColor ?? Colors.white),
              ),
            ),
          ),
          Visibility(
            visible: widget.zoomButtonEnabled,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: () {
                  if (_controller.camera.zoom < 17) {
                    _controller.move(LatLng(_latitude, _longitude),
                        _controller.camera.zoom + 1);
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: widget.sideButtonsColor ?? Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10)),
                child: Icon(Icons.zoom_in_map,
                    color: widget.sideButtonsIconColor ?? Colors.white),
              ),
            ),
          ),
          Visibility(
            visible: widget.zoomButtonEnabled,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: () {
                  if (_controller.camera.zoom > 0) {
                    _controller.move(LatLng(_latitude, _longitude),
                        _controller.camera.zoom - 1);
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: widget.sideButtonsColor ?? Colors.black87,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10)),
                child: Icon(Icons.zoom_out_map,
                    color: widget.sideButtonsIconColor ?? Colors.white),
              ),
            ),
          ),
          Visibility(
            visible: widget.myLocationButtonEnabled,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextButton(
                onPressed: () async {
                  // Check for location permission
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }

                  if (permission == LocationPermission.denied ||
                      permission == LocationPermission.deniedForever) {
                    // Handle permission denied case
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Location permission denied")),
                    );
                    return;
                  }

                  // Get the current location
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );

                    _move = true;
                    _latitude = position.latitude;
                    _longitude = position.longitude;
                    _controller.move(LatLng(_latitude, _longitude), 16);

                    // Optionally, you can fetch the location details here
                    _getLocationResult();
                  } catch (e) {
                    // Handle error (e.g., GPS not available)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error getting location: $e")),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: widget.sideButtonsColor ?? Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.my_location,
                  color: widget.sideButtonsIconColor ?? Colors.white,
                ),
              ),
            ),
          ),
          widget.sideWidget != null
              ? widget.sideWidget!(
                  _locationResult ??
                      LocationResult(
                          latitude: _latitude,
                          longitude: _longitude,
                          completeAddress: null,
                          placemark: null,
                          locationName: null),
                  _controller)
              : Container(),
        ],
      );
    }

    return FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: LatLng(_latitude, _longitude),
        initialZoom: 16,
        maxZoom: 18,
        onMapReady: () {
          _controller.mapEventStream.listen((evt) async {
            _timer?.cancel();
            if (!_move) {
              _timer = Timer(const Duration(milliseconds: 200), () {
                _latitude = evt.camera.center.latitude;
                _longitude = evt.camera.center.longitude;
                _getLocationResult();
              });
            } else {
              _move = false;
            }

            setState(() {});
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: _mapType == MapType.normal
              ? "http://tile.openstreetmap.org/{z}/{x}/{y}.png"
              : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.jpg',
          userAgentPackageName: 'com.example.app',
        ),
        Stack(
          children: [
            Center(
                child: widget.centerWidget != null
                    ? widget.centerWidget!
                    : Icon(Icons.food_bank_sharp,
                        size: 60,
                        color: widget.indicatorColor != null
                            ? widget.indicatorColor!
                            : Colors.black87)),
            Positioned(top: 10, left: 10, right: 10, child: searchBar()),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: sideButton(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    viewLocationName(),
                  ],
                )),
          ],
        )
      ],
    );
  }
}

/// Widget for showing the picked location address
class LocationItem extends StatefulWidget {
  /// Background color for the container
  final Color? backgroundColor;

  /// Indicator color for the container
  final Color? indicatorColor;

  /// Text Style for the address text
  final TextStyle? addressTextStyle;

  /// Text Style for the location name text
  final TextStyle? locationNameTextStyle;

  /// The location data for the picked location
  final Location data;

  final Function(LocationResult locationResult) onResultClicked;

  const LocationItem(
      {super.key,
      required this.data,
      this.backgroundColor,
      this.addressTextStyle,
      this.indicatorColor,
      this.locationNameTextStyle,
      required this.onResultClicked});

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  List<Placemark> _placemarks = [];

  _getLocationResult() async {
    _placemarks = await placemarkFromCoordinates(
        widget.data.latitude, widget.data.longitude);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getLocationResult();
  }

  @override
  Widget build(BuildContext context) {
    if (_placemarks.isEmpty) {
      return Container(
        color: widget.backgroundColor ?? Colors.white,
        padding: const EdgeInsets.all(10),
        child: const Center(
            child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        )),
      );
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onResultClicked(LocationResult(
                latitude: widget.data.latitude,
                longitude: widget.data.longitude,
                completeAddress:
                    getCompleteAdress(placemark: _placemarks[index]),
                placemark: _placemarks[index],
                locationName: getLocationName(placemark: _placemarks[index])));
          },
          child: Container(
            color: widget.backgroundColor ?? Colors.white,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: widget.indicatorColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getLocationName(placemark: _placemarks[index]),
                      style: widget.locationNameTextStyle ??
                          Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      getCompleteAdress(placemark: _placemarks[index]),
                      style: widget.addressTextStyle ??
                          Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ))
              ],
            ),
          ),
        );
      },
      itemCount: _placemarks.length > 3 ? 3 : _placemarks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}

// Future<LocationResult> getLocationResult(
//     {required double latitude, required double longitude}) async {
//   try {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     if (placemarks.isNotEmpty) {
//       return LocationResult(
//           latitude: latitude,
//           longitude: longitude,
//           locationName: getLocationName(placemark: placemarks.first),
//           completeAddress: getCompleteAdress(placemark: placemarks.first),
//           placemark: placemarks.first);
//     } else {
//       return LocationResult(
//           latitude: latitude,
//           longitude: longitude,
//           completeAddress: null,
//           placemark: null,
//           locationName: null);
//     }
//   } catch (e) {
//     return LocationResult(
//         latitude: latitude,
//         longitude: longitude,
//         completeAddress: null,
//         placemark: null,
//         locationName: null);
//   }
// }

Future<LocationResult> getLocationResult({
  required double latitude,
  required double longitude,
}) async {
  try {
    if (kIsWeb) {
      // ✅ For Web: Use OpenStreetMap Nominatim API
      final url =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';
      final response = await http.get(Uri.parse(url), headers: {
        'User-Agent': 'FlutterApp (fahadk8080@gmail.com)',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final displayName = data['display_name'];

        return LocationResult(
          latitude: latitude,
          longitude: longitude,
          locationName: displayName,
          completeAddress: displayName,
          placemark: null,
        );
      } else {
        return LocationResult(
          latitude: latitude,
          longitude: longitude,
          completeAddress: null,
          locationName: null,
          placemark: null,
        );
      }
    } else {
      // ✅ For Android/iOS
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return LocationResult(
          latitude: latitude,
          longitude: longitude,
          locationName: getLocationName(placemark: placemark),
          completeAddress: getCompleteAdress(placemark: placemark),
          placemark: placemark,
        );
      } else {
        return LocationResult(
          latitude: latitude,
          longitude: longitude,
          completeAddress: null,
          locationName: null,
          placemark: null,
        );
      }
    }
  } catch (e) {
    return LocationResult(
      latitude: latitude,
      longitude: longitude,
      completeAddress: null,
      locationName: null,
      placemark: null,
    );
  }
}

String getLocationName({required Placemark placemark}) {
  /// Returns throughfare or subLocality if name is an unreadable street code
  if (isStreetCode(placemark.name ?? "")) {
    if ((placemark.thoroughfare ?? "").isEmpty) {
      return placemark.subLocality ?? "-";
    } else {
      return placemark.thoroughfare ?? "=";
    }
  }

  /// Returns name if it is same with street
  else if (placemark.name == placemark.street) {
    return placemark.name ?? "-";
  }

  /// Returns street if name is part of name (like house number)
  else if (placemark.street
          ?.toLowerCase()
          .contains(placemark.name?.toLowerCase() ?? "") ==
      true) {
    return placemark.street ?? "-";
  }
  return placemark.name ?? "-";
}

String getCompleteAdress({required Placemark placemark}) {
  /// Returns throughfare or subLocality if name is an unreadable street code
  if (isStreetCode(placemark.name ?? "")) {
    if ((placemark.thoroughfare ?? "").isEmpty) {
      return "${placemark.subLocality},${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
    } else {
      return "${placemark.thoroughfare}, ${placemark.subLocality},${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
    }
  }

  /// Returns name if it is same with street
  else if (placemark.name == placemark.street) {
    return "${placemark.street}, ${placemark.subLocality},${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
  }

  /// Returns street if name is part of name (like house number)
  else if (placemark.street
          ?.toLowerCase()
          .contains(placemark.name?.toLowerCase() ?? "") ==
      true) {
    return "${placemark.street}, ${placemark.subLocality},${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
  }
  return "${placemark.name}, ${placemark.street}, ${placemark.subLocality},${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}";
}

bool isStreetCode(String text) {
  final streetCodeRegex = RegExp(
      r"^[A-Z0-9\-+]+$"); // Matches all uppercase letters, digits, hyphens, and plus signs
  return streetCodeRegex.hasMatch(text);
}

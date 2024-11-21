import 'package:geocode/geocode.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class LocationUtils {
  /**
   * 该方法可以获得Location对象
   * 使用方法如下：
   *      final LocationUtils locationUtils = LocationUtils();
   *      LocationData? locationData = await locationUtils.getLocation();
   */
  Future<LocationData?> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // 检查是否启用定位服务
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null; // 如果服务未启用，返回 null
      }
    }

    // 检查是否有权限使用位置服务
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      // 如果没有权限，返回 null
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // 获取位置数据
    return await location.getLocation();
  }

  Future<String> getAddress(double lat, double lang) async {
    //   if (lat == null || lang == null) return "";
    //   GeoCode geoCode = GeoCode();
    //   Address address =
    //   await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    //   return "${address.streetAddress}, ${address.city}, ${address
    //       .countryName}, ${address.postal}";
    // }


    return "123123";
  }
}

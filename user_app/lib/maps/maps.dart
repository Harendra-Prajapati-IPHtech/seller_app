import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  static Future<void> openMapWithPosition(
      String lattitude, String longitude) async {
    String googlMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$lattitude,$longitude";

    if (await canLaunchUrl(googlMapUrl as Uri)) {
      await launchUrl(googlMapUrl as Uri);
    } else {
      throw "Could not open the map. ";
    }
  }

  static Future<void> openMapWithAddress(String fullAddress) async {
    String query = Uri.encodeComponent(fullAddress);
    final Uri _url =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    // String googlMapUrl =
    //     "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw "Could not open the map. ";
    }
  }
}

import 'package:url_launcher/url_launcher.dart';

class MapUtiles {
  MapUtiles._();

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    // Vérifiez si l'URL peut être lancée
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(
        googleUrl,
        mode: LaunchMode
            .externalApplication, // Lancer dans une application externe
      );
    } else {
      print('Cannot launch URL: $googleUrl');
      throw 'Could not launch $googleUrl';
    }
  }
}

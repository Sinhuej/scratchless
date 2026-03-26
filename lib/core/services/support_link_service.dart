import 'package:url_launcher/url_launcher.dart';

class SupportLinkService {
  static final Uri _callUri = Uri(
    scheme: 'tel',
    path: '1-800-697-3738',
  );

  static final Uri _textUri = Uri(
    scheme: 'sms',
    path: '800426',
  );

  static final Uri _chatUri = Uri.parse(
    'https://www.ncpgambling.org/chat/',
  );

  static final Uri _helpHomeUri = Uri.parse(
    'https://www.ncpgambling.org/help-treatment/',
  );

  static final Uri _helpByStateUri = Uri.parse(
    'https://www.ncpgambling.org/help-treatment/help-by-state/',
  );

  static Future<bool> launchCall() async {
    return launchUrl(_callUri);
  }

  static Future<bool> launchText() async {
    return launchUrl(_textUri);
  }

  static Future<bool> launchChat() async {
    return launchUrl(_chatUri);
  }

  static Future<bool> launchHelpHome() async {
    return launchUrl(_helpHomeUri);
  }

  static Future<bool> launchHelpByState() async {
    return launchUrl(_helpByStateUri);
  }
}

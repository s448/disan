// ignore: depend_on_referenced_packages
import 'package:flutter_share/flutter_share.dart';

class ShareService {
  static shareSomething(title, text, url) async {
    FlutterShare.share(
      title: title,
      text: text,
      chooserTitle: title,
      linkUrl: url,
    );
  }
}

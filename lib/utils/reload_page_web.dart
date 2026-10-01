// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

void reloadPage() {
  js.context.callMethod('eval', ['window.location.reload()']);
}

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<void> registerBrowserCloseHandler(
  Future<void> Function() onClose,
) async {
  html.window.onBeforeUnload.listen((event) async {
    try {
      await onClose();
    } catch (_) {}
  });

  html.document.onVisibilityChange.listen((event) async {
    if (html.document.visibilityState == "hidden") {
      try {
        await onClose();
      } catch (_) {}
    }
  });
}

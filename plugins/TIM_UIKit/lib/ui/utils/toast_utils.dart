import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_record_plus/widgets/custom_overlay.dart';

class ToastUtils {
  static showToast({BuildContext? context, String msg = '', TextStyle? style,}) {
    OverlayEntry? overlayEntry;
    int _count = 0;
    void removeOverlay() {
      overlayEntry?.remove();
      overlayEntry = null;
    }
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (content) {
        return Container(
          child:  Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff77797A),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                msg,
                style: style ?? const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      });
      Overlay.of(context!).insert(overlayEntry!);
      Timer.periodic(const Duration(seconds: 1), (timer) {
        _count++;
        if (_count == 2) {
          _count = 0;
          timer.cancel();
          removeOverlay();
        }
      });
    }
  }

}
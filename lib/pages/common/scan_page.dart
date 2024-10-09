import 'dart:async';

import 'package:bee_chat/utils/ab_route.dart';
import 'package:bee_chat/utils/ab_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  final MobileScannerController cameraController = MobileScannerController();
  String? scanStr;
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    _subscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                if (scanStr != null) {
                  return;
                }
                if (capture.barcodes.isNotEmpty) {
                  scanStr = capture.barcodes.first.rawValue;
                  if (scanStr != null) {
                    ABRoute.pop(result: scanStr);
                  }
                }
              },
            ),
          ),
          Positioned(
            bottom: 80.px,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DecoratedBox(
                //   decoration: const ShapeDecoration(
                //     shape: CircleBorder(),
                //     color: Colors.white,
                //   ),
                //   child: IconButton(
                //     color: Colors.grey,
                //     icon: const Icon(Icons.image),
                //     iconSize: 32.px,
                //     onPressed: () {
                //       // 选择相册
                //     },
                //   ),
                // ),
                // SizedBox(width: 120.px),
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.white,
                  ),
                  child: IconButton(
                    color: Colors.grey,
                    icon: const Icon(
                      Icons.cameraswitch,
                    ),
                    iconSize: 32.px,
                    onPressed: () => cameraController.switchCamera(),
                  ),
                ),
              ],
            ),
          ),
          // 返回按钮
          Positioned(
            top: ABScreen.statusHeight + 6,
            left: 16,
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: IconButton(
                icon: Icon(CupertinoIcons.arrow_left,),
                onPressed: () => ABRoute.pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

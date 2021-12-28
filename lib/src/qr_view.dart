import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sdui/sdui.dart';

import 'widget.dart';

/// Descriptor of a [QRView]
///
/// ### JSON Attributes
///  - *action*: Action to invoke once the QR code scanned
class SDUIQrView extends SDUIWidget {
  @override
  Widget toWidget(BuildContext context) => _QRViewStatefulWidget(this);
}

class _QRViewStatefulWidget extends StatefulWidget {
  final SDUIQrView delegate;

  const _QRViewStatefulWidget(this.delegate);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _QRViewState(delegate);
}

class _QRViewState extends State<_QRViewStatefulWidget> {
  final SDUIQrView delegate;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  _QRViewState(this.delegate);

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: (controller) => _onQRViewCreated(context, controller),
      );

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      delegate.action.execute(context, {
        'code': scanData.code,
        'format': scanData.format
      }).then((value) => delegate.action.handleResult(context, value));
    });
  }
}

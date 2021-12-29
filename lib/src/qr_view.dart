import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'loading.dart';
import 'route.dart';
import 'widget.dart';

/// Descriptor of a [QRView]
///
/// ### JSON Attributes
///  - *submitUrl*: URL where to submit the data
class SDUIQrView extends SDUIWidget {
  String submitUrl;

  SDUIQrView({this.submitUrl = ''});

  @override
  Widget toWidget(BuildContext context) => _QRViewStatefulWidget(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    submitUrl = json?["submitUrl"] ?? '';
    return super.fromJson(json);
  }
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
  Barcode? barcode;

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
  Widget build(BuildContext context) => barcode == null
      ? QRView(
          key: qrKey,
          onQRViewCreated: (controller) =>
              _onQRViewCreated(context, controller),
          overlay: QrScannerOverlayShape(
            borderRadius: 10,
            borderWidth: 5,
            borderColor: Colors.red,
          ),
        )
      : Center(child: sduiProgressIndicator(context));

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((data) {
      controller.pauseCamera();
      setState(() {
        barcode = data;
      });

      var provider = HttpRouteContentProvider(delegate.submitUrl,
          data: {'code': data.code, 'format': data.format.formatName});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DynamicRoute(provider: provider)),
      );
    });
  }
}

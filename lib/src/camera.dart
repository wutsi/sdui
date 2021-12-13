import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

import 'form.dart';
import 'loading.dart';
import 'widget.dart';

List<CameraDescription> sduiCameras = [];

/// Descriptor of a [Camera].
/// ## Attribute ##
/// - **name**: Name of the form field of the file.
/// - **uploadUrl**: URL where to upload the file
/// - **lensDirection**: Lens direction (default: `back`)
class SDUICamera extends SDUIWidget with SDUIFormField {
  String? name;
  String? uploadUrl;
  String? lensDirection;

  @override
  Widget toWidget(BuildContext context) => _CameraWidgetStateful(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"];
    uploadUrl = json?["uploadUrl"];
    lensDirection = json?["lensDirection"];
    return super.fromJson(json);
  }
}

class _CameraWidgetStateful extends StatefulWidget {
  final SDUICamera delegate;

  const _CameraWidgetStateful(this.delegate, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _CameraWidgetState(delegate);
}

class _CameraWidgetState extends State<_CameraWidgetStateful> {
  SDUICamera delegate;
  bool buzy = false;
  late CameraDescription _camera;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  _CameraWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    if (_cameraAvailable()) {
      _camera = findCamera(delegate.lensDirection) ?? sduiCameras[0];
      _controller = _createCameraController(_camera);
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_cameraAvailable()) {
      _controller.dispose();
    }
  }

  bool _cameraAvailable() => sduiCameras.isNotEmpty;

  bool _cameraNotAvailable() => !_cameraAvailable();

  @override
  Widget build(BuildContext context) => _cameraNotAvailable()
      ? Container()
      : FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return buzy
                  ? Center(child: sduiProgressIndicator(context))
                  : CameraPreview(_controller,
                      child: Container(
                        width: 68,
                        alignment: Alignment.bottomLeft,
                        child: sduiCameras.length == 1
                            ? _pictureButton()
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [_pictureButton()],
                              ),
                      ));
            } else {
              return Center(child: sduiProgressIndicator(context));
            }
          },
        );

  Widget _pictureButton() => FloatingActionButton(
      child: const Icon(Icons.camera_alt, size: 48),
      enableFeedback: true,
      onPressed: () => _takePicture());

  CameraDescription? findCamera(String? lensDirection) {
    CameraLensDirection direction = _toLensDirection(lensDirection);
    List<CameraDescription> cameras = sduiCameras
        .where((element) => element.lensDirection == direction)
        .toList();
    return cameras.isEmpty ? null : cameras[0];
  }

  CameraLensDirection _toLensDirection(String? lensDirection) {
    switch (lensDirection?.toLowerCase()) {
      case "front":
        return CameraLensDirection.front;
      case "external":
        return CameraLensDirection.external;
      default:
        return CameraLensDirection.back;
    }
  }

  CameraController _createCameraController(CameraDescription camera) =>
      CameraController(camera, ResolutionPreset.medium, enableAudio: false);

  void _takePicture() async {
    _setBuzy(true);
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();
      final name = delegate.name ?? 'file';

      if (delegate.uploadUrl != null) {
        Http.getInstance()
            .upload(delegate.uploadUrl!, name, image)
            .then((value) => delegate.action.execute(context, null));
      }
    } finally {
      _setBuzy(false);
    }
  }

  void _setBuzy(bool flag) {
    setState(() {
      buzy = flag;
    });
  }
}

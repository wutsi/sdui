import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

import 'form.dart';
import 'widget.dart';

List<CameraDescription> sduiCameras = [];

/// Descriptor of a [Camera]
class SDUICamera extends SDUIWidget with SDUIFormField {
  String? name;
  String? uploadUrl;

  @override
  Widget toWidget(BuildContext context) => _CameraWidgetStateful(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"];
    uploadUrl = json?["uploadUrl"];
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

    if (sduiCameras.isNotEmpty) {
      _camera = sduiCameras[0];
      _controller = _createCameraController(_camera);
      _initializeControllerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => sduiCameras.isEmpty
      ? Container()
      : FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller,
                  child: Container(
                    width: 68,
                    alignment: Alignment.bottomLeft,
                    child: sduiCameras.length == 1
                        ? _pictureButton()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [_pictureButton(), _flipButton()],
                          ),
                  ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );

  Widget _pictureButton() {
    if (buzy) {
      return FloatingActionButton(
        child: const CircularProgressIndicator(),
        onPressed: () => {},
      );
    } else {
      return FloatingActionButton(
          child: const Icon(Icons.camera_alt, size: 48),
          enableFeedback: true,
          onPressed: () => _takePicture());
    }
  }

  Widget _flipButton() {
    return FloatingActionButton(
        child: const Icon(Icons.flip_camera_ios_rounded, size: 48),
        enableFeedback: true,
        onPressed: () => _flipCamera());
  }

  void _flipCamera() {
    var nextDirection = _camera.lensDirection == CameraLensDirection.front
        ? CameraLensDirection.back
        : CameraLensDirection.front;

    var nextCamera = sduiCameras
        .where((element) => element.lensDirection == nextDirection)
        .toList();
    if (nextCamera.isNotEmpty) {
      setState(() {
        _controller.dispose();

        _camera = nextCamera[0];
        _controller = _createCameraController(_camera);
      });
    }
  }

  CameraController _createCameraController(CameraDescription camera) =>
      CameraController(camera, ResolutionPreset.medium);

  void _takePicture() async {
    await _initializeControllerFuture;

    final image = await _controller.takePicture();
    final name = delegate.name ?? 'file';

    _setBuzy(true);
    _upload(name, image)
        .then((value) => delegate.action.execute(context, null))
        .whenComplete(() => _setBuzy(false));
  }

  void _setBuzy(bool flag) {
    setState(() {
      buzy = flag;
    });
  }

  Future<void> _upload(String name, XFile file) async {
    if (delegate.uploadUrl == null) return;

    Http.getInstance().upload(delegate.uploadUrl!, name, file);
  }
}

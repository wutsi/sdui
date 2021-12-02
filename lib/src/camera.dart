import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'form.dart';
import 'widget.dart';

List<CameraDescription> sduiCameras = [];

/// Descriptor of a [Camera]
class SDUICamera extends SDUIWidget with SDUIFormField {
  String? name;

  @override
  Widget toWidget(BuildContext context) => _CameraWidgetStateful(this);

  @override
  SDUIWidget fromJson(Map<String, dynamic>? json) {
    name = json?["name"];
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
  late CameraDescription _camera;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  _CameraWidgetState(this.delegate);

  @override
  void initState() {
    super.initState();

    if (sduiCameras.isNotEmpty) {
      _camera = sduiCameras[0];
      _controller = CameraController(_camera, ResolutionPreset.medium);
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
              return Column(
                children: [
                  CameraPreview(_controller),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: FloatingActionButton(
                      child: const Icon(Icons.camera_alt, size: 48),
                      onPressed: () async {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        final image = await _controller.takePicture();
                        final name = delegate.name ?? 'image';
                        delegate.provider?.setData(name, image.path);
                      },
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';
import 'package:sdui/src/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Http.getInstance().interceptors = [
    HttpJsonInterceptor(),
    HttpAuthorizationInterceptor()
  ];

  sduiCameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      initialRoute: '/',
      routes: _routes(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [sduiRouteObserver],
    );
  }

  Map<String, WidgetBuilder> _routes() => {
        '/': (context) => const HomeScreen(),
        '/remote': (context) => const DynamicRoute(
            provider: HttpRouteContentProvider('http://localhost:8080/send')),
        '/static': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(json))
      };
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with RouteAware {
  int state = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      sduiRouteObserver.subscribe(this, ModalRoute.of(context)!);
    });

    super.initState();
  }

  @override
  void dispose() {
    sduiRouteObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Column(children: [
          Text(state.toString()),
          ElevatedButton(
              child: const Text('Remote'),
              onPressed: () => Navigator.pushNamed(context, '/remote')),
          const Spacer(),
          ElevatedButton(
              child: const Text('Static'),
              onPressed: () => Navigator.pushNamed(context, '/static')),
        ]),
      );

  @override
  void didPopNext() {
    setState(() {
      state++;
    });
  }

  @override
  void didPush() {
    setState(() {
      state++;
    });
  }
}

var json = '''
{
	"type": "Screen",
	"attributes": {
		"safe": false
	},
	"children": [{
		"type": "Camera"
	}],
	"appBar": {
		"type": "AppBar",
		"attributes": {
			"title": "Add Cash",
			"elevation": 0.0,
			"backgroundColor": "#FFFFFF",
			"foregroundColor": "#000000"
		},
		"children": []
	}
}
''';

/// HTTP interceptor that adds Authorization header
class HttpAuthorizationInterceptor extends HttpInterceptor {
  @override
  void onRequest(RequestTemplate request) async {
    String token =
        'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIxNiIsInN1Yl90eXBlIjoiVVNFUiIsInNjb3BlIjpbImNvbnRhY3QtbWFuYWdlIiwiY29udGFjdC1yZWFkIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLW1hbmFnZSIsInBheW1lbnQtbWV0aG9kLXJlYWQiLCJwYXltZW50LXJlYWQiLCJwYXltZW50LXJlYWQiLCJzbXMtc2VuZCIsInNtcy12ZXJpZnkiLCJ0ZW5hbnQtcmVhZCIsInVzZXItbWFuYWdlIiwidXNlci1yZWFkIl0sImlzcyI6Ind1dHNpLmNvbSIsIm5hbWUiOiJIZXJ2ZSBUY2hlcGFubm91IiwiYWRtaW4iOmZhbHNlLCJwaG9uZV9udW1iZXIiOiIrMTUxNDc1ODAxOTEiLCJleHAiOjE2MzgyODM2NTQsImlhdCI6MTYzODE5OTA1NCwianRpIjoiMSJ9.YZ62GDn_XeHRpQyqqVlAPT4lRYwIyM2qSpRjzTmgrz8xvPoXimizZQfTBuVI7KqnsAMg_ax-nggE-DzzwTShiQYvXGrzYeZV811o21e2G0_p5_rBAoQXXXivvA24ZaiU7YYL88SyJCHG6Veo4PpPkx4P3oqG03k1c31N_WOTbKA-2OrIFBSIHvPAr8030wN5kt26jiobrNAJW5ltZ7mPJ1d7aXfbmoqtZCELfrfZ0faugSG3l60azyDamxyexlTmwYgePUQUtuZkQXCsg-BRbdEkCGsMPcAsZAwbUuz_7Ja2yV8iAaW6TXlB-o_LqjoBUmem74GOUttmqONa5afgWg';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['X-Tenant-ID'] = '1';
  }

  @override
  void onResponse(ResponseTemplate response) {
    // TODO: implement onResponse
  }
}

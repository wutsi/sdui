import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Http.getInstance().interceptors = [
    HttpJsonInterceptor(),
    HttpAuthorizationInterceptor()
  ];
  DynamicRouteState.statusCodeRoutes[401] = '/401';

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
            provider: HttpRouteContentProvider(
                'http://10.0.2.2:8080/settings/store')),
        '/static': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(json)),
        '/401': (context) => const Error401()
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

class Error401 extends StatelessWidget {
  const Error401({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const Center(child: Text('401'));
}

var json = '''
{
  "type": "Screen",
  "appBar": {
    "type": "AppBar",
    "attributes": {
      "title": "Profile"
    }
  },
  "child": {
    "type": "Form",
    "attributes": {
      "padding": 10
    },
    "children": [
      {
        "type": "Input",
        "attributes": {
          "name": "first_name",
          "value": "Ray",
          "caption": "First Name",
          "maxLength": 30
        }
      },
      {
        "type": "Input",
        "attributes": {
          "name": "last_name",
          "value": "Sponsible",
          "caption": "Last Name",
          "maxLength": 30
        }
      },
      {
        "type": "Input",
        "attributes": {
          "name": "email",
          "value": "ray.sponsible@gmail.com",
          "caption": "Email *",
          "required": true
        }
      },
      {
        "type": "Input",
        "attributes": {
          "type": "date",
          "name": "birth_date",
          "caption": "Date of Birth"
        }
      },
      {
        "type": "Input",
        "attributes": {
          "type": "Submit",
          "name": "submit",
          "caption": "Create Profile"
        },
        "action": {
          "type": "Command",
          "url": "https://myapp.herokuapp.com/commands/save-profile",
          "prompt": {
            "type": "Dialog",
            "attributes": {
              "type": "confirm",
              "title": "Confirmation",
              "message": "Are you sure you want to change your profile?"
            }
          }
        }
      }
    ]
  }
}
''';

/// HTTP interceptor that adds Authorization header
class HttpAuthorizationInterceptor extends HttpInterceptor {
  @override
  void onRequest(RequestTemplate request) async {
    String token =
        'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJ0ZW5hbnRfaWQiOjEsInN1YiI6IjE2Iiwic3ViX3R5cGUiOiJVU0VSIiwic2NvcGUiOlsiY2FydC1tYW5hZ2UiLCJjYXJ0LXJlYWQiLCJjYXRhbG9nLW1hbmFnZSIsImNhdGFsb2ctcmVhZCIsImNvbnRhY3QtbWFuYWdlIiwiY29udGFjdC1yZWFkIiwibWFpbC1zZW5kIiwib3JkZXItbWFuYWdlIiwib3JkZXItcmVhZCIsInBheW1lbnQtbWFuYWdlIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1yZWFkIiwicGF5bWVudC1yZWFkIiwicGF5bWVudC1yZWFkIiwicXItbWFuYWdlIiwicXItcmVhZCIsInNtcy1zZW5kIiwic21zLXZlcmlmeSIsInRlbmFudC1yZWFkIiwidXNlci1tYW5hZ2UiLCJ1c2VyLXJlYWQiXSwiaXNzIjoid3V0c2kuY29tIiwibmFtZSI6IkhlcnZlIFRjaGVwYW5ub3UiLCJhZG1pbiI6ZmFsc2UsInBob25lX251bWJlciI6IisxNTE0NzU4MDE5MSIsImV4cCI6MTY0NTU1NTI2OSwiaWF0IjoxNjQ1NDcwNjY5LCJqdGkiOiIxIn0.du2nLpJdvWWgJNrsdLckG2rvb2nIb9wcKolE2spIM1ESdCOOlGpuIoB5iFj08d_VUjRoQbP7XNrNt5EcALs7EYj-9wqVkw33BKzHQNq_aGcOU5LOcWiqCow-F29irFAO3GLe9r0w1xFS7u1_K-NAVUXRP7ot3EZCrC0nIUkRsB9-flcR2VqO5c0R6b1XfDzW';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['X-Tenant-ID'] = '1';
    request.headers['X-Environment'] = 'dev';
  }

  @override
  void onResponse(ResponseTemplate response) {
    // TODO: implement onResponse
  }
}

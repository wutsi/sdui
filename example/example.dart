import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Http.getInstance().interceptors = [
    HttpJsonInterceptor(),
    HttpAuthorizationInterceptor()
  ];

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
      navigatorObservers: [routeObserver],
    );
  }

  Map<String, WidgetBuilder> _routes() => {
        '/': (context) => HomeScreen(),
        '/remote': (context) => DynamicRoute(
            provider: HttpRouteContentProvider(
                'http://localhost:8080/cashin/pending')),
        '/static': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(json))
      };
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with RouteAware {
  int state = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);

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
    print('didPopNext. state=$state');
    setState(() {
      state++;
    });
  }

  @override
  void didPush() {
    print('didPush. state=$state');
    setState(() {
      state++;
    });
  }
}

var json = '''
{
  "type" : "Screen",
  "attributes" : {
    "safe" : false
  },
  "children" : [ {
    "type" : "Container",
    "attributes" : {
      "alignment" : "Center",
      "padding" : 20.0
    },
    "children" : [ {
      "type" : "Column",
      "attributes" : { },
      "children" : [ {
        "type" : "Form",
        "attributes" : { },
        "children" : [ {
          "type" : "Container",
          "attributes" : {
            "padding" : 10.0
          },
          "children" : [ {
            "type" : "MoneyWithKeyboard",
            "attributes" : {
              "name" : "amount",
              "moneyColor" : "#1D7EDF",
              "deleteText" : "Delete",
              "maxLength" : 10,
              "currency" : "XAF"
            },
            "children" : [ ]
          } ]
        }, {
          "type" : "Container",
          "attributes" : {
            "padding" : 10.0
          },
          "children" : [ {
            "type" : "Input",
            "attributes" : {
              "name" : "command",
              "hideText" : false,
              "required" : false,
              "caption" : "Add Cash",
              "enabled" : true,
              "readOnly" : false,
              "type" : "Submit",
              "minLength" : 0
            },
            "children" : [ ],
            "action" : {
              "type" : "Command",
              "url" : "http://localhost:8080/commands/cashin"
            }
          } ]
        } ]
      } ]
    } ]
  } ],
  "appBar" : {
    "type" : "AppBar",
    "attributes" : {
      "title" : "Add Cash",
      "elevation" : 0.0,
      "backgroundColor" : "#FFFFFF",
      "foregroundColor" : "#000000"
    },
    "children" : [ ]
  }
}
''';

/// HTTP interceptor that adds Authorization header
class HttpAuthorizationInterceptor extends HttpInterceptor {
  @override
  void onRequest(RequestTemplate request) async {
    String token =
        'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIxNiIsInN1Yl90eXBlIjoiVVNFUiIsInNjb3BlIjpbInBheW1lbnQtbWFuYWdlIiwicGF5bWVudC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1tYW5hZ2UiLCJwYXltZW50LW1ldGhvZC1yZWFkIiwicGF5bWVudC1yZWFkIiwicGF5bWVudC1yZWFkIiwidGVuYW50LXJlYWQiLCJ1c2VyLW1hbmFnZSIsInVzZXItcmVhZCJdLCJpc3MiOiJ3dXRzaS5jb20iLCJuYW1lIjoiSGVydmUgVGNoZXBhbm5vdSIsImFkbWluIjpmYWxzZSwicGhvbmVfbnVtYmVyIjoiKzE1MTQ3NTgwMTkxIiwiZXhwIjoxNjM2ODQxMzk5LCJpYXQiOjE2MzY3NTY3OTksImp0aSI6IjEifQ.kqnN1e3cZG_XXzlC8HPnVWtnlDIDCi-rFH9uAum3GV994xw_LK4o5hjdb64MAOww9KFmg_IkYkHTIWfRZXjNJH_JSIzO_5AQF6Kh8U-zAxxJ_YIapGO10eFEu4iFY3XiDx00aYONUqe2YSMsLrMw_OZMll3T0plfQmIG7tFhEZ-hBvfQUWfTiqAUxutqH3SN_V2-_IslfB467rjFTI9IGvXo2EGvJTczUSZqBZpBLVkOKxOwQjFGL6Yr_E';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['X-Tenant-ID'] = '1';
  }

  @override
  void onResponse(ResponseTemplate response) {
    // TODO: implement onResponse
  }
}

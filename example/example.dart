import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Http
      .getInstance()
      .interceptors = [
    HttpJsonInterceptor(),
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
      navigatorObservers: [sduiRouteObserver],
    );
  }

  Map<String, WidgetBuilder> _routes() =>
      {

        '/': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(homeJson)),

        '/static': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(staticJson)),

        '/remote': (context) =>
        const DynamicRoute(
            provider: HttpRouteContentProvider(
                'http://10.0.2.2:8080/settings/store' /* Remove endpoint - Replace it with your own */
            )),
      };
}

var homeJson = '''
{
  "type": "Screen",
  "appBar": {
    "type": "AppBar",
    "attributes": {
      "title": "Home"
    }
  },
  "bottomNavigationBar": {
    "type": "BottomNavigationBar",
    "attributes":{
      "background": "#1D7EDF",
      "selectedItemColor": "#ffffff",
      "unselectedItemColor": "#ffffff"
    },
    "children":[
      {
        "type": "BottomNavigationBarItem",
        "attributes": {
          "icon": "f107",
          "caption": "Home"
        },
        "action":{
          "type": "Route",
          "url": "route:~/"
        }
      },
      {
        "type": "BottomNavigationBarItem",
        "attributes": {
          "icon": "f27b",
          "caption": "Me"
        },
        "action":{
          "type": "Route",
          "url": "route:/static"
        }
      },
      {
        "type": "BottomNavigationBarItem",
        "attributes": {
          "icon": "e211",
          "caption": "Remote"
        },
        "action":{
          "type": "Route",
          "url": "route:/remote"
        }
      }
    ]
  },
  "child": {
    "type": "Center",
    "children": [
      {
        "type": "Text",
        "attributes": {
          "caption": "Sample Project"
        }
      }
    ]
  }
}
''';

var staticJson = '''
{
  "type": "Screen",
  "appBar": {
    "type": "AppBar",
    "attributes": {
      "title": "Profile"
    }
  },
  "bottomNavigationBar": {
    "type": "BottomNavigationBar",
    "attributes":{
      "background": "#1D7EDF",
      "selectedItemColor": "#ffffff",
      "unselectedItemColor": "#ffffff"
    },
    "children":[
      {
        "type": "BottomNavigationBarItem",
        "attributes": {
          "icon": "f107",
          "caption": "Home"
        },
        "action":{
          "type": "Route",
          "url": "route:~/"
        }
      },
      {
        "type": "BottomNavigationBarItem",
        "attributes": {
          "icon": "f27b",
          "caption": "Me"
        },
        "action":{
          "type": "Route",
          "url": "route:/static"
        }
      },
      {
        "type": "BottomNavigationBarItem",
        "attributes": {
          "icon": "e211",
          "caption": "Remote"
        },
        "action":{
          "type": "Route",
          "url": "route:/remote"
        }
      }
    ]
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

import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

import 'my_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register 3rd party widgets
  SDUIWidgetRegistry.getInstance().register('MyWidget', () => MyWidget());

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
        '/': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(homeJson)),
        '/static': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(staticJson)),
        '/remote': (context) => const DynamicRoute(
            provider: HttpRouteContentProvider(
                'http://10.0.2.2:8080/settings' /* Remove endpoint - Replace it with your own */
                )),
      };
}

var homeJson = '''
{
  "type": "Screen",
  "appBar": {
    "type": "AppBar",
    "attributes": {
      "title": "Home",
      "actions":[
        {
          "type": "Container",
          "attributes": {
            "padding": 10.0
          },
          "children":[
            {
              "type": "Icon",
              "attributes":{
                "code": "f27b"
              }
            }
          ],
          "action":{
            "type": "Route",
            "url": "route:/static",
            "trackEvent": "event01"
          }
        }
      ]
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
          "url": "route:/~",
          "trackEvent": "event-home"
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
        "type": "MyWidget",
        "attributes": {
          "caption": "Sample Project",
          "padding": 5.0,
          "margin": 5.0
        }
      }
    ]
  },
  "attributes":{
    "id": "page.home"
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
          "url": "route:/~"
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
          "name": "phone",
          "type": "phone",
          "caption": "Phone",
          "required": true,
          "initialCountry": "CM",
          "value": "+237690000001"
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
          "trackEvent": "create-event",
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
  },
  "attributes":{
    "id": "page.static"
  }
}
''';

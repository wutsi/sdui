import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

const String home = '''
{
	"type": "Screen",
	"attributes": {
		"title": "Home"
	},
	"child": {
    "type": "Column",
    "children": [
      {
        "type": "Container",
        "attributes":{
          "alignment": "center",
          "padding": 10
        },
        "child": {
          "type": "Button",
          "attributes": {
            "caption": "Settings"
          },
          "action": {
            "type": "screen",
            "url": "route:/wutsi/settings"
          }
        }
      },
      {
        "type": "Container",
        "attributes":{
          "alignment": "center",
          "padding": 10
        },
        "child":{
          "type": "Button",
          "attributes": {
            "caption": "Checkout"
          },
          "action": {
            "type": "screen",
            "url": "route:/wutsi/checkout"
          }
        }
      },
      {
        "type": "Container",
        "attributes":{
          "alignment": "center",
          "padding": 10
        },
        "child":{
          "type": "Button",
          "attributes": {
            "caption": "Onboard"
          },
          "action": {
            "type": "screen",
            "url": "http://localhost:8080/app/demo/onboard"
          }
        }
      },
      {
        "type": "Container",
        "attributes":{
          "padding": 10,
          "margin": 10,
          "border": 1,
          "borderColor": "#000000"
        },
        "child":{
          "type": "Image",
          "attributes": {
            "url": "icons/Icon-192.png"
          }
        }
      },
      {
        "type": "Container",
        "attributes":{
          "padding": 10,
          "margin": 10,
          "border": 1,
          "borderColor": "#000000"
        },
        "child":{
          "type": "Icon",
          "attributes": {
            "code": "e415"
          }
        }
      }
    ]
	}
}
''';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo', initialRoute: '/', routes: _routes());
  }

  Map<String, WidgetBuilder> _routes() => {
        '/': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(home)),
        '/wutsi/settings': (context) => DynamicRoute(
            provider: HttpRouteContentProvider(
                'http://localhost:8080/app/demo/settings')),
        '/wutsi/checkout': (context) => DynamicRoute(
            provider: HttpRouteContentProvider(
                'http://localhost:8080/app/demo/checkout'))
      };
}

import 'package:flutter/material.dart';
import 'package:sdui/sdui.dart';

void main() async {
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
    );
  }

  Map<String, WidgetBuilder> _routes() => {
        '/': (context) => Scaffold(
              appBar: AppBar(title: const Text('Home')),
              body: Column(children: [
                ElevatedButton(
                    child: const Text('Remote'),
                    onPressed: () => Navigator.pushNamed(context, '/remote')),
                const Spacer(),
                ElevatedButton(
                    child: const Text('Static'),
                    onPressed: () => Navigator.pushNamed(context, '/static')),
              ]),
            ),
        '/remote': (context) => DynamicRoute(
            provider: HttpRouteContentProvider(
                'https://wutsi-onboard-bff-test.herokuapp.com')),
        '/static': (context) =>
            DynamicRoute(provider: StaticRouteContentProvider(json))
      };
}

var json = '''
{
	"type": "Screen",
	"appBar": {
	  "type": "AppBar",
	  "attributes":{
	    "title": "Title"
	  },
	  "children": [
	    {
	      "type": "IconButton",
	      "attributes": {
	        "icon": "e166"
	      },
	      "action":{
	        "type": "Prompt",
	        "prompt":{
	          "title": "Yo",
	          "message": "Man"
	        }
	      }
	    }
	  ]
	},
	"child": {
		"type": "Form",
		"attributes": {
			"padding": 10
		},
		"children": [{
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
					"caption": "Email",
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
        "type": "DropdownButton",
        "attributes": {
          "name": "payment_method",
          "hint": "Select your Payment Method",
          "required": true
        },
        "children":[
          {
            "type": "DropdownMenuItem",
            "attributes": {
              "caption": "MTN",
              "value": "MTN"
            }
          },
          {
            "type": "DropdownMenuItem",
            "attributes": {
              "caption": "Orange",
              "value": "ORANGE"
            }
          },
          {
            "type": "DropdownMenuItem",
            "attributes": {
              "caption": "Nexttel",
              "value": "NEXTTEL"
            }
          }
        ]
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
					"url": "http://localhost:8080/actuator/health",
					"prompt": {
						"type": "Confirm",
						"title": "Confirmation",
						"message": "Are you sure you want to change your profile?"
					}
				}
			}
		]
	}
}
''';

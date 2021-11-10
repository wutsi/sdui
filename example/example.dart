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
            provider: HttpRouteContentProvider('http://localhost:8080')),
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

/// HTTP interceptor that adds Authorization header
class HttpAuthorizationInterceptor extends HttpInterceptor {
  @override
  void onRequest(RequestTemplate request) async {
    String token =
        'eyJraWQiOiIxIiwidHlwIjoiSldUIiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiIxNiIsInN1Yl90eXBlIjoiVVNFUiIsInNjb3BlIjpbInBheW1lbnQtbWFuYWdlIiwicGF5bWVudC1tZXRob2QtbWFuYWdlIiwicGF5bWVudC1tZXRob2QtcmVhZCIsInBheW1lbnQtcmVhZCIsInRlbmFudC1yZWFkIiwidXNlci1tYW5hZ2UiLCJ1c2VyLXJlYWQiXSwiaXNzIjoid3V0c2kuY29tIiwibmFtZSI6IkhlcnZlIFRjaGVwYW5ub3UiLCJhZG1pbiI6ZmFsc2UsInBob25lX251bWJlciI6IisxNTE0NzU4MDE5MSIsImV4cCI6MTYzNjU0NzEwNiwiaWF0IjoxNjM2NDYyNTA2LCJqdGkiOiIxIn0.B3c8umpS6o4tku9dTidVcnk_QYnRA-vPMejehrchSF5BAfcceg_u-Say9bPokJSgeK_nu0h2ouP3TAERV4FuN28i6oHEGkuPWQP8gnH0AouqSNw862APOMcOEP5Z0ve45kzC-LnHkLFhiF1Neaumt09BQLCfX7nK8RtKbZ0Mb2iZXaqoRz_6LYqbo9rn6UmC_GIFGMVdsepvh0pZuqw8L561IdvWe-Rx4DIoXCVMw37mJk29fjQPCon0q7SIluRfmpPw2x0bC_mY1kBGrF2-bEEM_VTdYjWoQDSD678TskcUBneqdNqNmLVJnoCuS0dnm-8s799rtP92kYpElDmNpg';
    request.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void onResponse(ResponseTemplate response) {
    // TODO: implement onResponse
  }
}

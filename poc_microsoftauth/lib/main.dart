import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAD OAuth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'AAD OAuth Home'),
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Must configure flutter to start the web server for the app on
  // the port listed below. In VSCode, this can be done with
  // the following run settings in launch.json
  // "args": ["-d", "chrome","--web-port", "8483"]
  static final Config config = Config(
    tenant: '77adbefb-aed4-4884-81f8-41fe6eef8e55',
    clientId: '1bfbd2b9-2e3f-4a2c-8ae2-ed4c14fb62dc',
    scope: 'openid profile offline_access',
    redirectUri: kIsWeb
        ? 'http://localhost:60936'
        : 'https://login.live.com/oauth20_desktop.srf',
    navigatorKey: navigatorKey,
  );
  final AadOAuth oauth = AadOAuth(config);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              'AzureAD OAuth',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            leading: Icon(Icons.launch),
            title: Text('Login'),
            onTap: () {
              login();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Logout'),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login() async {
    try {
      await oauth.login();
      var accessToken = await oauth.getAccessToken();
      showMessage('Logged in successfully, your access token: $accessToken');
    } catch (e) {
      showError(e);
    }
  }

  void logout() async {
    await oauth.logout();
    showMessage('Logged out');
  }
}


// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:poc_microsoftauth/firebase_options.dart';



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {


//   //Metodo encargado de llamar a la libreria firebase_auth_oauth,
//   //pasarle las credenciales de cualquier servicion(en este caso microsoft)
//   // y abrir una ventana con el form de login

//   Future<void> performLogin(String provider, List<String> scopes,
//       Map<String, String> parameters) async {
//     try {
//       await FirebaseAuthOAuth().openSignInFlow(provider, scopes, parameters);
//     } on PlatformException catch (error) {
//       /**
//        * The plugin has the following error codes:
//        * 1. FirebaseAuthError: FirebaseAuth related error
//        * 2. PlatformError: An platform related error
//        * 3. PluginError: An error from this plugin
//        */
//       debugPrint("${error.code}: ${error.message}");
//     }
//   }

//   Future<void> performLink(String provider, List<String> scopes,
//       Map<String, String> parameters) async {
//     try {
//       await FirebaseAuthOAuth()
//           .linkExistingUserWithCredentials(provider, scopes, parameters);
//     } on PlatformException catch (error) {
//       /**
//        * The plugin has the following error codes:
//        * 1. FirebaseAuthError: FirebaseAuth related error
//        * 2. PlatformError: An platform related error
//        * 3. PluginError: An error from this plugin
//        */
//       debugPrint("${error.code}: ${error.message}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//           ),
//           body: StreamBuilder(
//               initialData: null,
//               stream: FirebaseAuth.instance.userChanges(),
//               builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
//                 return Column(
//                   children: [
//                     Center(
//                       child: Text(
//                           snapshot.data == null ? "Logged out" : "Logged In"),
//                     ),
//                     if (snapshot.data == null ||
//                         snapshot.data?.isAnonymous == true) ...[
                      
//                       ElevatedButton(
//                         onPressed: () async {
//                           await performLogin("microsoft.com", [
//                             "email openid"
//                           ], {
//                             'tenant': '77adbefb-aed4-4884-81f8-41fe6eef8e55'
//                           });
//                         },
//                         child: Text("Sign in By Microsoft"),
//                       ),
                     
//                     ],
//                     if (snapshot.data != null) ...[
//                       ElevatedButton(
//                         onPressed: () async {
//                           await FirebaseAuth.instance.signOut();
//                         },
//                         child: Text("Logout"),
//                       )
//                     ]
//                   ],
//                 );
//               })),
//     );
//   }
// }

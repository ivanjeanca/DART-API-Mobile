import 'package:flutter/material.dart';
import 'package:flutter_wepapi/dashboard.dart';
import 'package:flutter_wepapi/productos.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_wepapi/login.dart';

import 'package:flutter_wepapi/clientes.dart';
import 'package:flutter_wepapi/insertarCliente.dart';

import 'package:flutter_wepapi/areas.dart';
import 'package:flutter_wepapi/insertarArea.dart';

void main() => runApp(Splash());

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<Splash>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(

      routes: {
        '/login'  : (context) => Login(),
        '/dashboard' : (context) => Dashboard(),
        '/productos' : (context) => Productos(),

        '/clientes' : (context) => Clientes(),
        '/insertar-cliente' : (context) => insertarCliente(),

        '/areas' : (context) => Areas(),
        '/insertar-area' : (context) => insertarArea(),
      },
      onUnknownRoute: (RouteSettings conf){
        return MaterialPageRoute(builder: (context)=>Productos());
      },

      title: "Bienvenido",
      home: SplashScreen(
        seconds: 2,
        navigateAfterSeconds: Login(),
        image: Image.network('http://storenyc.com/wp-content/uploads/2018/11/STORE-Logo.png'),
        gradientBackground: new LinearGradient(
          colors: [Colors.white, Color.fromARGB(255, 33, 37, 41)],
          begin: Alignment.center,
          end: Alignment.bottomCenter),
        photoSize: 150.0,
        loaderColor: Colors.white,
      ),
    );
  }
}
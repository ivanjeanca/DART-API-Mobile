import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'package:flutter_wepapi/login.dart';

import 'package:flutter_wepapi/dashboard.dart';

import 'package:flutter_wepapi/productos.dart';

import 'package:flutter_wepapi/areas.dart';
import 'package:flutter_wepapi/insertarArea.dart';

import 'package:flutter_wepapi/areasCliente.dart';
import 'package:flutter_wepapi/insertarAreaCliente.dart';

import 'package:flutter_wepapi/clientes.dart';
import 'package:flutter_wepapi/insertarCliente.dart';

import 'package:flutter_wepapi/pedidos.dart';
import 'package:flutter_wepapi/pedidosInfo.dart';
import 'package:flutter_wepapi/insertarPedido.dart';

import 'package:flutter_wepapi/productoAreaCliente.dart';
import 'package:flutter_wepapi/insertarProductoAreaCliente.dart';


void main() => runApp(Splash());

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<Splash>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      routes: {
        '/login'  : (context) => Login(),
        '/dashboard' : (context) => Dashboard(),

        '/productos' : (context) => Productos(),

        '/clientes' : (context) => Clientes(),
        '/insertar-cliente' : (context) => insertarCliente(),

        '/areas-cliente' : (context) => AreasCliente(),
        '/insertar-area-cliente' : (context) => insertarAreaCliente(),

        '/areas' : (context) => Areas(),
        '/insertar-area' : (context) => insertarArea(),

        '/producto-area-cliente' : (context) => ProductoAreaCliente(),
        '/insertar-producto-area-cliente' : (context) => insertarProductoAreaCliente(),

        '/pedidos' : (context) => pedidos(),
        '/pedidos-info' : (context) => pedidosInfo(),
        '/insertar-pedido' : (context) => insertarPedido(),

      },
      onUnknownRoute: (RouteSettings conf){
        return MaterialPageRoute(builder: (context)=>Productos());
      },

      title: "Bienvenido",
      debugShowCheckedModeBanner: false,
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
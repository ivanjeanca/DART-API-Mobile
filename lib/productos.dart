import 'package:flutter/material.dart';
import 'package:flutter_wepapi/models/productos.dart';
import 'package:flutter_wepapi/tarjeta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Productos extends StatefulWidget {
  @override
  ProductosState createState() => ProductosState();
}

class ProductosState extends State<Productos>{
  List<DAOProductos> tarjetas = List();

  @override
  void initState() {
    super.initState();
    getProductos();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: tarjetas.length,
          itemBuilder: (BuildContext context, int index) {
            return Tarjeta(tarjetas[index]);
          },
        ),
      ),
    );
  }

  Future<DAOProductos> getProductos() async{
    http.Response response = await http.get(
      Uri.encodeFull("http://192.168.1.76:8888/productos"),
      headers: { "Accept" : "application/json"}
    );
    if( response.statusCode == 200 ) {
      List product = json.decode(response.body);
      var productos = product.map((producto) => DAOProductos.fromJson(producto)).toList();
      setState(() {
        tarjetas.addAll(productos);
      });
    } else
      throw Exception('Fallo al obtener los datos');
  }
}
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_wepapi/pedidosInfo.dart';
import 'package:flutter_wepapi/Strings.dart';

class pedidos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return pedidosState();
  }
}

class pedidosState extends State<pedidos> {
  List dataPedidos;
  var isLoading = false;

  Future<String> getData() async {
    this.setState(() {
      isLoading = true;
    });

    var response = await http.get(Uri.encodeFull(Strings.direccion + "pedidos"),
        headers: {"Accept": "application/json"});

    // Metodo para renderizar el listado con los elementos
    this.setState(() {
      dataPedidos = json.decode(response.body);
      isLoading = false;
    });
    return "success";
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataPedidos == null ? 0 : dataPedidos.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pedidosInfo(
                                id: dataPedidos[index]['id_cliente'],
                              ),
                        )),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      child: Card(
                        elevation: 0.0,
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255,
                                  242 + ((index % 2) * 13),
                                  242 + ((index % 2) * 13),
                                  242 + ((index % 2) * 13)),
                              borderRadius: BorderRadius.circular(0)),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 1.0, color: Colors.black))),
                                child: Icon(Icons.shopping_cart,
                                    color: Colors.black)),
                            title: Text(
                              dataPedidos[index]['nombre'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: (Icon(Icons.add)),
        backgroundColor: Color.fromARGB(255, 40, 167, 69),
        onPressed: () {
          Navigator.pushNamed(context, '/insertar-pedido');
        },
      ),
    );
  }

  Future<String> getArea(id) async {
    var response = await http.get(
        Uri.encodeFull(Strings.direccion + "areas/" + id.toString()),
        headers: {"Accept": "application/json"});

    List data;
    data = json.decode(response.body);

    return data[0]['area'];
  }

  Future<http.Response> deleteProductoAreaCliente(id) async {
    final URL = Strings.direccion + 'productosareascliente/' + id.toString();
    final headers = {'Content-Type': 'application/json'};

    var response = await http.delete(URL, headers: headers);

    return response;
  }
}

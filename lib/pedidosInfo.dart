import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_wepapi/pedidoDetalle.dart';
import 'package:flutter_wepapi/Strings.dart';
import 'package:toast/toast.dart';

class pedidosInfo extends StatefulWidget {
  final id;

  pedidosInfo({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return pedidosInfoState(id);
  }
}

class pedidosInfoState extends State<pedidosInfo> {
  List dataPedidos;
  var isLoading = false;
  var idcliente;

  pedidosInfoState(id) {
    idcliente = id;
    print("id = " + idcliente.toString());
  }

  Future<String> getData() async {
    this.setState(() {
      isLoading = true;
    });

    var response = await http.get(
        Uri.encodeFull(Strings.direccion + "pedidos/" + idcliente.toString()),
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
        title: Text('Pedidos de ' +
            ((dataPedidos == null) ? "" : dataPedidos[0]['nombre'])),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount:
                  dataPedidos == null ? 0 : dataPedidos[0]['pedido'].length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pedidoDetalle(
                                id: dataPedidos[0]['pedido'][index]['id_pedido'],
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
                              "Pedido #" +
                                  dataPedidos[0]['pedido'][index]['id_pedido']
                                      .toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "Fecha de pedido: " +
                                    dataPedidos[0]['pedido'][index]
                                            ['fecha_pedido']
                                        .toString()
                                        .substring(0, 10) +
                                    "\nFecha de envio: " +
                                    dataPedidos[0]['pedido'][index]
                                            ['fecha_pedido']
                                        .toString()
                                        .substring(0, 10),
                                style: TextStyle(color: Colors.black)),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    )
                );
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

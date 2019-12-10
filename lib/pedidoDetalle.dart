import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_wepapi/Strings.dart';

class pedidoDetalle extends StatefulWidget {
  final id;

  pedidoDetalle({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return pedidoDetalleState(id);
  }
}

class pedidoDetalleState extends State<pedidoDetalle> {
  List dataPedidos;
  var isLoading = false;
  var idpedido;

  pedidoDetalleState(id) {
    idpedido = id;
    print("id = " + idpedido.toString());
  }

  Future<String> getData() async {
    this.setState(() {
      isLoading = true;
    });

    var response = await http.get(
        Uri.encodeFull(
            Strings.direccion + "detallepedido/" + idpedido.toString()),
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
        title: Text('Pedido #' +
            ((dataPedidos == null)
                ? ""
                : dataPedidos[0]['pedido']['id_pedido'].toString())),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: ListView(
                  shrinkWrap: false,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                  children: <Widget>[
                    Text(
                      "Pedido con folio: " + dataPedidos[0]['pedido']['id_pedido'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Producto comprado: \"" + dataPedidos[0]['producto']['producto'].toString() + "\".",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Precio unitario: \$" + dataPedidos[0]['precio'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    Text(
                      "Descuento por unidad: \$" + dataPedidos[0]['descuento'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    Text(
                      "Unidades compradas: " + dataPedidos[0]['cantidad'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      "Total de la compra: \$" + ((dataPedidos[0]['precio'] - dataPedidos[0]['descuento']) * dataPedidos[0]['cantidad']).toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Fecha de compra: " + dataPedidos[0]['pedido']['fecha_pedido'].toString().substring(0, 10) + " a las " + dataPedidos[0]['pedido']['fecha_pedido'].toString().substring(11, 19) +" hrs.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "Fecha de envio: " + dataPedidos[0]['pedido']['fecha_envio'].toString().substring(0, 10) + " a las " + dataPedidos[0]['pedido']['fecha_envio'].toString().substring(11, 19) +" hrs.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Atendido/a por: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      dataPedidos[0]['pedido']['empleado']['nombre'] + " " + dataPedidos[0]['pedido']['empleado']['apaterno'] + " " + dataPedidos[0]['pedido']['empleado']['amaterno'],
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17.0,
                        color: Color.fromARGB(255, 33, 37, 41),
                      ),
                    ),
                  ]
              ),
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

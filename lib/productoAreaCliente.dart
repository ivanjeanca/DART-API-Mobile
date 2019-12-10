import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import 'package:flutter_wepapi/editarProductoAreaCliente.dart';
import 'package:flutter_wepapi/Strings.dart';

class ProductoAreaCliente extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductoAreaClienteState();
  }
}

class ProductoAreaClienteState extends State<ProductoAreaCliente> {
  List dataProductoAreaCliente;
  var isLoading = false;
  var areatexto = "";

  Future<String> getData() async {
    this.setState(() {
      isLoading = true;
    });

    var response = await http.get(
        Uri.encodeFull(Strings.direccion + "productosareascliente"),
        headers: {"Accept": "application/json"});

    // Metodo para renderizar el listado con los elementos
    this.setState(() {
      dataProductoAreaCliente = json.decode(response.body);
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
        title: Text('Producto área cliente'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataProductoAreaCliente == null
                  ? 0
                  : dataProductoAreaCliente.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
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
                            child:
                                Icon(Icons.shopping_cart, color: Colors.black)),
                        title: Text(
                          dataProductoAreaCliente[index]['producto']
                              ['producto'],
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        subtitle: FutureBuilder(
                            future: getArea(dataProductoAreaCliente[index]
                                ['areascliente']['area']['id_area']),
                            initialData: "Loading text..",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> text) {
                              return new Row(
                                children: <Widget>[
                                  Flexible(
                                      child: Text(
                                          "Área: " +
                                              text.data +
                                              "\nCliente: " +
                                              dataProductoAreaCliente[index]
                                                      ['areascliente']
                                                  ['cliente']['nombre'] +
                                              "\nConsumo: " +
                                              dataProductoAreaCliente[index]
                                                      ['consumo']
                                                  .toString(),
                                          style:
                                              TextStyle(color: Colors.black)))
                                ],
                              );
                            }),
                        trailing: Icon(Icons.keyboard_arrow_right,
                            color: Colors.black, size: 30.0),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                        caption: 'Editar',
                        color: Color.fromARGB(255, 23, 162, 184),
                        icon: Icons.mode_edit,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editarProductoAreaCliente(
                                    id: dataProductoAreaCliente[index]
                                        ['id_producto_area_cliente'],
                                  ),
                            ))),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Eliminar',
                      color: Color.fromARGB(255, 52, 58, 64),
                      icon: Icons.delete_outline,
                      onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title:
                                    new Text("Eliminar producto área cliente"),
                                content: new Text(
                                    "¿Realmente quieres eliminar el \"" +
                                        dataProductoAreaCliente[index]
                                            ['producto']['producto'] +
                                        "\" con área \"" +
                                        dataProductoAreaCliente[index]
                                                    ['areascliente']['area']
                                                ['id_area']
                                            .toString() +
                                        "\" con el cliente \"" +
                                        dataProductoAreaCliente[index]
                                                ['areascliente']['cliente']
                                            ['nombre'] +
                                        "\"?"),
                                actions: <Widget>[
                                  new RaisedButton(
                                    child: new Text("Cerrar"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    color: Color.fromARGB(255, 33, 37, 41),
                                    textColor: Colors.white,
                                  ),
                                  new RaisedButton(
                                    child: new Text("Eliminar"),
                                    onPressed: () async {
                                      var response =
                                          await deleteProductoAreaCliente(
                                              dataProductoAreaCliente[index]
                                                  ['id_producto_area_cliente']);
                                      print(
                                          "Eliminar producto area cliente statusCode: " +
                                              response.statusCode.toString());
                                      if (response.statusCode == 200) {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacementNamed(
                                            context, '/producto-area-cliente');
                                        Toast.show("Área eliminada", context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.BOTTOM);
                                      } else {
                                        print("error al eliminar");
                                      }
                                    },
                                    color: Color.fromARGB(255, 220, 53, 69),
                                    textColor: Colors.white,
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: (Icon(Icons.add)),
        backgroundColor: Color.fromARGB(255, 40, 167, 69),
        onPressed: () {
          Navigator.pushNamed(context, '/insertar-producto-area-cliente');
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
    final URL =
        Strings.direccion + 'productosareascliente/' + id.toString();
    final headers = {'Content-Type': 'application/json'};

    var response = await http.delete(URL, headers: headers);

    return response;
  }
}

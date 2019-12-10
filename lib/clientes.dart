import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import 'package:flutter_wepapi/editarCliente.dart';
import 'package:flutter_wepapi/Strings.dart';

class Clientes extends StatefulWidget{
 @override
  State<StatefulWidget> createState() {
    return ClientesState();
  }
}

class ClientesState extends State<Clientes>{
  List dataClientes;
  var isLoading = false;

  Future<String> getData() async{
    this.setState((){
      isLoading = true;
    });

    var response = await http.get(
      Uri.encodeFull(Strings.direccion + "clientes"),
      headers: { "Accept" : "application/json"}
    );

    // Metodo para renderizar el listado con los elementos
    this.setState((){
      dataClientes = json.decode(response.body);
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
          title: Text('Clientes'),
          backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: isLoading ? Center( child: CircularProgressIndicator())
            :ListView.builder(
              itemCount: dataClientes == null ? 0 : dataClientes.length,
              itemBuilder: (BuildContext context, int index){
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  child: Card(
                    elevation: 0.0,
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 242 + ((index % 2) * 13), 242 + ((index % 2) * 13), 242 + ((index % 2) * 13)),
                          borderRadius: BorderRadius.circular(0)
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                      width: 1.0,
                                      color: Colors.black
                                  )
                              )
                            ),
                            child: Icon(
                                Icons.contacts,
                                color: Colors.black
                            )
                          ),

                          title: Text(
                              dataClientes[index]['nombre'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                          ),

                          subtitle: Row(
                            children: <Widget>[
                              Text(dataClientes[index]['correo']+"\n"+dataClientes[index]['telefono']+"\n"+dataClientes[index]['direccion'],
                                  style: TextStyle(
                                      color: Colors.black
                                  )
                              )
                            ],
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                            size: 30.0
                          ),
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
                            builder: (context) => editarCliente(id: dataClientes[index]['id_cliente'],),
                          ))
                    ),
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
                            title: new Text("Eliminar cliente"),
                            content: new Text("¿Realmente quieres eliminar al cliente \"" + dataClientes[index]['nombre'].toString() + "\"?"),
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
                                  var response = await deleteCliente(dataClientes[index]['id_cliente']);
                                  print("Guardar cliente statusCode: " + response.statusCode.toString());
                                  if( response.statusCode == 200 ){
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacementNamed(context,'/clientes');
                                    Toast.show("Cliente eliminado", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
        child: (
          Icon(Icons.add)
        ),
        backgroundColor: Color.fromARGB(255, 40, 167, 69),
        onPressed: (){
          Navigator.pushNamed(context, '/insertar-cliente');
        },
      ),
    );
  }

  Future<http.Response> deleteCliente(id) async {
    final URL = Strings.direccion + 'clientes/' + id.toString();
    final headers = {'Content-Type': 'application/json'};

    var response = await http.delete(
        URL,
        headers: headers
    );

    return response;
  }
}
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

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
      Uri.encodeFull("http://192.168.1.107:8888/clientes"),
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
      appBar: AppBar(title: Text('Listado de Clientes'), backgroundColor: Colors.blue),
      body: isLoading ? Center( child: CircularProgressIndicator())
            :ListView.builder(
              itemCount: dataClientes == null ? 0 : dataClientes.length,
              itemBuilder: (BuildContext context, int index){
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Card(
                    elevation: 8.0,
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: BoxDecoration(color: Color.fromRGBO(121, 181, 237, .9)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                        leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: BoxDecoration(
                              border: Border( right: BorderSide(width: 1.0, color: Colors.black))
                            ),
                            child: Icon(Icons.language, color: Colors.black)
                          ),
                        
                          title: Text(
                              dataClientes[index]['nomCliente'],
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),

                          subtitle: Row(
                            children: <Widget>[
                              //Icon(Icons.touch_app, color: Colors.yellowAccent),
                              Text(dataClientes[index]['emailCliente'], style: TextStyle(color: Colors.black))
                            ],
                          ),

                          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0,),
                        ),
                      ),
                  ),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Archive',
                      color: Colors.blue,
                      icon: Icons.archive,
                      //onTap: () => _showSnackBar('Archive'),
                    ),
                    IconSlideAction(
                      caption: 'Share',
                      color: Colors.indigo,
                      icon: Icons.share,
                      //onTap: () => _showSnackBar('Share'),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.lightGreenAccent,
                      icon: Icons.edit,
                      //onTap: () => _showSnackBar('More'),
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      //onTap: () => _showSnackBar('Delete'),
                    ),
                  ],
                );
            },
          ),
      floatingActionButton: FloatingActionButton(
        child: (
          Icon(Icons.add_circle)
        ),
        onPressed: (){ Navigator.pushReplacementNamed(context, '/frmctes');},
      ),
    );
  }
}
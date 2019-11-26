import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FrmClientes extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Clientes'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Guardar Cliente'),
          onPressed: () async { 
            var response = await guardarCliente();
            if( response.statusCode == 200 ){
              //final snackbar = SnackBar(content: Text('El cliente se insertó correctamente!!!'),);
              //Scaffold.of(context).showSnackBar(snackbar);
              Navigator.pushReplacementNamed(context,'/ctes');
            }
          },
        ),
      ),
    );
  }

  Future<http.Response> guardarCliente() async{
    final URL = 'http://192.168.1.107:8888/clientes';
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {'nomCliente': 'GKN', 'dirCliente': 'Celaya', 'emailCliente': 'seguridad@gkn.com.mx', 'telCliente': '34567890'};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    var response = await http.post(
      URL,
      headers: headers,
      body: jsonBody,
      encoding: encoding
    );

    return response;
  }

}
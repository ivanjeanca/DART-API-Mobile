import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_wepapi/Strings.dart';

class insertarCliente extends StatelessWidget{
  final txtNombre = TextEditingController();
  final txtCorreo = TextEditingController();
  final txtDireccion = TextEditingController();
  final txtTelefono = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insertar cliente'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: Center(
        child: ListView(
            shrinkWrap: false,
            padding: EdgeInsets.only(top: 40.0, left: 24.0, right: 24.0),
            children: <Widget>[
              Text(
                "Nombre del cliente",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtNombre,
                decoration: InputDecoration(
                  hintText: 'Nombre',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Dirección",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtDireccion,
                decoration: InputDecoration(
                  hintText: 'Dirección',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Correo electrónico",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtCorreo,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Teléfono",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtTelefono,
                decoration: InputDecoration(
                  hintText: 'Teléfono',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text('Guardar Cliente'),
                color: Color.fromARGB(255, 33, 37, 41),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onPressed: () async {
                  var response = await guardarCliente();
                  print("Guardar cliente statusCode: " + response.statusCode.toString());
                  if( response.statusCode == 200 ){
                    Navigator.pushReplacementNamed(context,'/clientes');
                    Toast.show("Cliente guardado", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
              ),
            ]),
      ),
    );
  }

  Future<http.Response> guardarCliente() async{
    final URL = Strings.direccion + 'clientes';
    final headers = {'Content-Type': 'application/json'};
    
    var correo = txtCorreo.text;
    var nombre = txtNombre.text;
    var telefono = txtTelefono.text;
    var direccion = txtDireccion.text;

    Map<String, dynamic> body =
    {
      'nombre': nombre,
      'direccion': direccion,
      'correo': correo,
      'telefono': telefono
    };

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
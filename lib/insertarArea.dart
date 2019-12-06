import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class insertarArea extends StatelessWidget{
  final txtArea = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insertar área'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: Center(
        child: ListView(
            shrinkWrap: false,
            padding: EdgeInsets.only(top: 40.0, left: 24.0, right: 24.0),
            children: <Widget>[
              Text(
                "Nombre del área",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtArea,
                decoration: InputDecoration(
                  hintText: 'Área',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text('Guardar área'),
                color: Color.fromARGB(255, 33, 37, 41),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onPressed: () async {
                  var response = await guardarArea();
                  print("Guardar area statusCode: " + response.statusCode.toString());
                  if( response.statusCode == 200 ){
                    Navigator.pushReplacementNamed(context,'/areas');
                    Toast.show("Área guardada", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
              ),
            ]),
      ),
    );
  }

  Future<http.Response> guardarArea() async{
    final URL = 'http://192.168.100.29:8888/areas';
    final headers = {'Content-Type': 'application/json'};
    var area = txtArea.text;

    Map<String, dynamic> body =
    {
      'area': area
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
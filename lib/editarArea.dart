import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class editarArea extends StatefulWidget{
  final id;
  editarArea({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return editarAreaState(id);
  }
}

class editarAreaState extends State<editarArea>{
  final txtArea = TextEditingController();
  List dataAreas;
  var isLoading = false;
  var idarea;

  editarAreaState(id){
    idarea = id;
  }

  Future<String> getData() async{
    this.setState((){
      isLoading = true;
    });

    var response = await http.get(
        Uri.encodeFull("http://192.168.100.29:8888/areas/" + idarea.toString()),
        headers: { "Accept" : "application/json"}
    );

    // Metodo para renderizar el listado con los elementos
    this.setState((){
      dataAreas = json.decode(response.body);
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
    if(!isLoading) {
      txtArea.text = dataAreas[0]['area'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar área'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body:  isLoading ? Center( child: CircularProgressIndicator()) : Center(
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
                  hintText: 'Nombre del área',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text('Actualizar área'),
                color: Color.fromARGB(255, 33, 37, 41),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onPressed: () async {
                  var response = await guardarArea(dataAreas[0]['id_area']);
                  print("Actualizar area statusCode: " + response.statusCode.toString());
                  if( response.statusCode == 200 ){
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context,'/areas');
                    Toast.show("Área actualizada", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } else {

                    print("error al actualizar");
                  }
                },
              ),
            ]),
      ),
    );
  }

  Future<http.Response> guardarArea(id) async{
    final URL = 'http://192.168.100.29:8888/areas/' + id.toString();
    final headers = {'Content-Type': 'application/json'};

    var area = txtArea.text;

    Map<String, dynamic> body =
    {
      'area': area,
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    var response = await http.put(
        URL,
        headers: headers,
        body: jsonBody,
        encoding: encoding
    );

    return response;
  }

  Future<http.Response> getArea(id) async {
    final URL = 'http://192.168.100.29:8888/areas/' + id.toString();
    final headers = {'Content-Type': 'application/json'};

    var response = await http.get(
        URL,
        headers: headers
    );

    return response;
  }
}
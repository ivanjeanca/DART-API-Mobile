import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class editarCliente extends StatefulWidget{
  final id;
  editarCliente({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return editarClienteState(id);
  }
}

class editarClienteState extends State<editarCliente>{
  final txtNombre = TextEditingController();
  final txtCorreo = TextEditingController();
  final txtDireccion = TextEditingController();
  final txtTelefono = TextEditingController();
  List dataClientes;
  var isLoading = false;
  var idcliente;

  editarClienteState(id){
    idcliente = id;
  }

  Future<String> getData() async{
    this.setState((){
      isLoading = true;
    });

    var response = await http.get(
        Uri.encodeFull("http://192.168.100.29:8888/clientes/" + idcliente.toString()),
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
    if(!isLoading) {
      txtNombre.text = dataClientes[0]['nombre'];
      txtDireccion.text = dataClientes[0]['direccion'];
      txtCorreo.text = dataClientes[0]['correo'];
      txtTelefono.text = dataClientes[0]['telefono'];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar cliente'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body:  isLoading ? Center( child: CircularProgressIndicator()) : Center(
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
                child: Text('Actualizar cliente'),
                color: Color.fromARGB(255, 33, 37, 41),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onPressed: () async {
                  var response = await guardarCliente(dataClientes[0]['id_cliente']);
                  print("Guardar cliente statusCode: " + response.statusCode.toString());
                  if( response.statusCode == 200 ){
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context,'/clientes');
                    Toast.show("Cliente actualizado", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } else {

                    print("error al actualizar");
                  }
                },
              ),
            ]),
      ),
    );
  }

  Future<http.Response> guardarCliente(id) async{
    final URL = 'http://192.168.100.29:8888/clientes/' + id.toString();
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

    var response = await http.put(
        URL,
        headers: headers,
        body: jsonBody,
        encoding: encoding
    );

    return response;
  }

  Future<http.Response> getCliente(id) async {
    final URL = 'http://192.168.100.29:8888/clientes/' + id.toString();
    final headers = {'Content-Type': 'application/json'};

    var response = await http.get(
        URL,
        headers: headers
    );

    return response;
  }
}
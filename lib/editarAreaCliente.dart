import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class editarAreaCliente extends StatefulWidget {
  final id;
  editarAreaCliente({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return editarAreaClienteState(id);
  }
}

class editarAreaClienteState extends State<editarAreaCliente>{
  final txtCliente = TextEditingController();
  final txtArea = TextEditingController();
  final txtDireccion = TextEditingController();
  final txtNumeroEmpleados = TextEditingController();

  List dataCliente, dataArea,dataAreaCliente;
  var isLoading = false;
  List<String> listaClientes = [];
  String listadoClientes = "ID  -  Cliente\n";
  String listadoAreas = "ID  -  Área\n";
  List<DropdownMenuItem<String>> dropDownItemsCliente = [];
  var idareacliente;

  editarAreaClienteState(id){
    idareacliente = id;
  }

  Future<String> getData() async{
    this.setState((){
      isLoading = true;
    });

    var clientes_response = await http.get(
        Uri.encodeFull("http://192.168.1.76:8888/clientes"),
        headers: { "Accept" : "application/json"}
    );
    var areas_response = await http.get(
        Uri.encodeFull("http://192.168.1.76:8888/areas"),
        headers: { "Accept" : "application/json"}
    );

    print("id area cliente " + idareacliente.toString());

    var areacliente_response = await http.get(
        Uri.encodeFull("http://192.168.1.76:8888/areascliente/" + idareacliente.toString()),
        headers: { "Accept" : "application/json"}
    );

    // Metodo para renderizar el listado con los elementos
    this.setState((){
      dataCliente = json.decode(clientes_response.body);
      dataArea = json.decode(areas_response.body);
      dataAreaCliente = json.decode(areacliente_response.body);
      isLoading = true;

      txtArea.text = dataAreaCliente[0]['area']['id_area'].toString();
      txtCliente.text = dataAreaCliente[0]['cliente']['id_cliente'].toString();
      txtNumeroEmpleados.text = dataAreaCliente[0]['numero_empleados'].toString();
    });

    if(dataArea.length > 0){
      for (var i = 0; i < dataArea.length; i++) {
        listadoAreas += ((dataArea[i]['id_area'] < 10) ? (" " + dataArea[i]['id_area'].toString()) : (dataArea[i]['id_area'].toString())) + "  -  " + dataArea[i]['area'] + "\n";
      }
    }

    if(dataCliente.length > 0) {
      for (var i = 0; i < dataCliente.length; i++) {
        listaClientes.add(dataCliente[i]['nombre']);
        listadoClientes += ((dataCliente[i]['id_cliente'] < 10) ? (" " + dataCliente[i]['id_cliente'].toString()) : (dataCliente[i]['id_cliente'].toString())) + "  -  " + dataCliente[i]['nombre'] + "\n";
      }

      for (String item in listaClientes) {
        dropDownItemsCliente.add(DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ));
      }
    }

    this.setState((){
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

    String dropdownValue;
    if(listaClientes.length > 0)
      dropdownValue = listaClientes[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Insertar área cliente'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: Center(
        child: ListView(
            shrinkWrap: false,
            padding: EdgeInsets.only(top: 40.0, left: 24.0, right: 24.0),
            children: <Widget>[
              Text(
                "Cliente",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                listadoClientes,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 15.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtCliente,
                decoration: InputDecoration(
                  hintText: 'ID del cliente',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              /*
              DropdownButton<String>(
                value: dropdownValue,
                iconSize: 24,
                elevation: 16,
                  onChanged: (selectedItem) => setState(() {
                    print(dropdownValue);
                    print(selectedItem);
                    dropdownValue = selectedItem;

                  }),
                items: dropDownItemsCliente
              ),
              */
              SizedBox(height: 30.0),
              Text(
                "Área",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                listadoAreas,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 15.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtArea,
                decoration: InputDecoration(
                  hintText: 'ID Área',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Número de empleados",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtNumeroEmpleados,
                decoration: InputDecoration(
                  hintText: 'Número de empleados',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text('Guardar área cliente'),
                color: Color.fromARGB(255, 33, 37, 41),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onPressed: () async {
                  var response = await guardarAreaCliente();
                  print("Guardar area cliente statusCode: " + response.statusCode.toString());
                  if( response.statusCode == 200 ){
                    Navigator.pushReplacementNamed(context,'/areas-cliente');
                    Toast.show("Área cliente guardada", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
              ),
            ]),
      ),
    );
  }

  Future<http.Response> guardarAreaCliente() async{
    final URL = "http://192.168.1.76:8888/areascliente/" + idareacliente.toString();
    final headers = {'Content-Type': 'application/json'};

    var id_area = txtArea.text;
    var id_cliente = txtCliente.text;
    var numero_empleados = txtNumeroEmpleados.text;

    Map<String, dynamic> body =
    {
      "numero_empleados": int.parse(numero_empleados),
      "area": {
        "id_area": int.parse(id_area)
      },
      "cliente": {
        "id_cliente": int.parse(id_cliente)
      }

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
}
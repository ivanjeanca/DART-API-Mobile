import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_wepapi/Strings.dart';

class editarProductoAreaCliente extends StatefulWidget {
  final id;
  editarProductoAreaCliente({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return editarProductoAreaClienteState(id);
  }
}

class editarProductoAreaClienteState extends State<editarProductoAreaCliente>{
  final txtProducto = TextEditingController();
  final txtAreaCliente = TextEditingController();
  final txtConsumo = TextEditingController();

  List dataProducto, dataAreaCliente, dataProductoAreaCliente;
  var isLoading = false;
  List<String> listaClientes = [];
  String listadoProducto = "ID  -  Producto\n";
  String listadoAreaCliente = "ID  -  Área / Cliente\n";
  List<DropdownMenuItem<String>> dropDownItemsCliente = [];
  var idproductoareacliente;

  editarProductoAreaClienteState(id){
    idproductoareacliente = id;
  }

  Future<String> getData() async{
    this.setState((){
      isLoading = true;
    });

    var producto_response = await http.get(
        Uri.encodeFull(Strings.direccion + "productos"),
        headers: { "Accept" : "application/json"}
    );
    var areacliente_response = await http.get(
        Uri.encodeFull(Strings.direccion + "areascliente"),
        headers: { "Accept" : "application/json"}
    );
    var productoareacliente_response = await http.get(
        Uri.encodeFull(Strings.direccion + "productosareascliente/" + idproductoareacliente.toString()),
        headers: { "Accept" : "application/json"}
    );

    // Metodo para renderizar el listado con los elementos
    this.setState((){
      dataProducto = json.decode(producto_response.body);
      dataAreaCliente = json.decode(areacliente_response.body);
      dataProductoAreaCliente = json.decode(productoareacliente_response.body);

      txtProducto.text = dataProductoAreaCliente[0]['producto']['id_producto'].toString();
      txtAreaCliente.text = dataProductoAreaCliente[0]['areascliente']['id_area_cliente'].toString();
      txtConsumo.text = dataProductoAreaCliente[0]['consumo'].toString();
      isLoading = true;
    });

    if(dataAreaCliente.length > 0){
      for (var i = 0; i < dataAreaCliente.length; i++) {
        listadoAreaCliente += ((dataAreaCliente[i]['id_area_cliente'] < 10) ? (" " + dataAreaCliente[i]['id_area_cliente'].toString()) : (dataAreaCliente[i]['id_area_cliente'].toString())) + "  -  " + dataAreaCliente[i]['area']['area'] + " / " + dataAreaCliente[i]['cliente']['nombre'] + "\n";
      }
    }

    if(dataProducto.length > 0) {
      for (var i = 0; i < dataProducto.length; i++) {
        listaClientes.add(dataProducto[i]['producto']);
        listadoProducto += ((dataProducto[i]['id_producto'] < 10) ? (" " + dataProducto[i]['id_producto'].toString()) : (dataProducto[i]['id_producto'].toString())) + "  -  " + dataProducto[i]['producto'] + "\n";
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
        title: Text('Editar producto área cliente'),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      body: Center(
        child: ListView(
            shrinkWrap: false,
            padding: EdgeInsets.only(top: 40.0, left: 24.0, right: 24.0),
            children: <Widget>[
              Text(
                "Producto",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                listadoProducto,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 15.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtProducto,
                decoration: InputDecoration(
                  hintText: 'ID del producto',
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
                "Área / Cliente",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                listadoAreaCliente,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 15.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtAreaCliente,
                decoration: InputDecoration(
                  hintText: 'ID del área cliente',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Consumo",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtConsumo,
                decoration: InputDecoration(
                  hintText: 'Consumo',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3.0),),
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text('Guardar producto área cliente'),
                color: Color.fromARGB(255, 33, 37, 41),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onPressed: () async {
                  var response = await guardarAreaCliente();
                  print("Guardar producto area cliente statusCode: " + response.statusCode.toString());
                  if( response.statusCode == 200 ){
                    Navigator.pushReplacementNamed(context,'/producto-area-cliente');
                    Toast.show("Producto área cliente guardado", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
              ),
            ]),
      ),
    );
  }

  Future<http.Response> guardarAreaCliente() async{
    final URL = Strings.direccion + 'productosareascliente/' + idproductoareacliente.toString();
    final headers = {'Content-Type': 'application/json'};

    var id_area_cliente = txtAreaCliente.text;
    var id_producto = txtProducto.text;
    var consumo = txtConsumo.text;

    Map<String, dynamic> body =
    {
      "areascliente": {
        "id_area_cliente": int.parse(id_area_cliente)
      },
      "producto": {
        "id_producto": int.parse(id_producto)
      },
      "consumo": int.parse(consumo),
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
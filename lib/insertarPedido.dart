import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_wepapi/Strings.dart';

class insertarPedido extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return insertarPedidoState();
  }
}

class insertarPedidoState extends State<insertarPedido> {
  final txtCliente = TextEditingController();
  final txtEmpleado = TextEditingController();
  final txtProducto = TextEditingController();
  final txtCantidad = TextEditingController();
  final txtDescuento = TextEditingController();

  List dataCliente, dataEmpleado, dataProducto;
  var isLoading = false;
  List<String> listaClientes = [];
  String listadoClientes = "ID  -  Cliente\n";
  String listadoEmpleados = "ID  -  Empleado\n";
  String listadoProductos = "ID  -  Producto\n";
  List<DropdownMenuItem<String>> dropDownItemsCliente = [];

  Future<String> getData() async {
    this.setState(() {
      isLoading = true;
    });

    var clientes_response = await http.get(
        Uri.encodeFull(Strings.direccion + "clientes"),
        headers: {"Accept": "application/json"});
    var empleados_response = await http.get(
        Uri.encodeFull(Strings.direccion + "empleados"),
        headers: {"Accept": "application/json"});
    var productos_response = await http.get(
        Uri.encodeFull(Strings.direccion + "productos"),
        headers: {"Accept": "application/json"});

    // Metodo para renderizar el listado con los elementos
    this.setState(() {
      dataCliente = json.decode(clientes_response.body);
      dataEmpleado = json.decode(empleados_response.body);
      dataProducto = json.decode(productos_response.body);
      isLoading = true;
    });

    if (dataEmpleado.length > 0) {
      for (var i = 0; i < dataEmpleado.length; i++) {
        listadoEmpleados += ((dataEmpleado[i]['id_empleado'] < 10)
                ? (" " + dataEmpleado[i]['id_empleado'].toString())
                : (dataEmpleado[i]['id_empleado'].toString())) +
            "  -  " +
            dataEmpleado[i]['nombre'] +
            " " +
            dataEmpleado[i]['apaterno'] +
            " " +
            dataEmpleado[i]['amaterno'] +
            "\n";
      }
    }
    if (dataProducto.length > 0) {
      for (var i = 0; i < dataProducto.length; i++) {
        listadoProductos += ((dataProducto[i]['id_producto'] < 10)
                ? (" " + dataProducto[i]['id_producto'].toString())
                : (dataProducto[i]['id_producto'].toString())) +
            "  -  " +
            dataProducto[i]['producto'] +
            "\n";
      }
    }

    if (dataCliente.length > 0) {
      for (var i = 0; i < dataCliente.length; i++) {
        listaClientes.add(dataCliente[i]['nombre']);
        listadoClientes += ((dataCliente[i]['id_cliente'] < 10)
                ? (" " + dataCliente[i]['id_cliente'].toString())
                : (dataCliente[i]['id_cliente'].toString())) +
            "  -  " +
            dataCliente[i]['nombre'] +
            "\n";
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

    this.setState(() {
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
    if (listaClientes.length > 0) dropdownValue = listaClientes[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Insertar pedido'),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
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
                "Empleado",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                listadoEmpleados,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 15.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtEmpleado,
                decoration: InputDecoration(
                  hintText: 'ID Empleado',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
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
                listadoProductos,
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
                  hintText: 'ID Producto',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Cantidad",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtCantidad,
                decoration: InputDecoration(
                  hintText: 'Cantidad',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                "Descuento",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  color: Color.fromARGB(255, 0, 100, 150),
                ),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: txtDescuento,
                decoration: InputDecoration(
                  hintText: 'Descuento',
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text('Guardar pedido'),
                color: Color.fromARGB(255, 33, 37, 41),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onPressed: () async {
                  var response = await guardarPedido();
                  print("Pedido statusCode: " + response.statusCode.toString());
                  if (response.statusCode == 200) {
                    Navigator.pushReplacementNamed(context, '/pedidos');
                    Toast.show("Pedido guardado", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } else {
                    Toast.show("Error al guardar", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
              ),
              SizedBox(height: 30.0),
            ]),
      ),
    );
  }

  Future<http.Response> guardarPedido() async {
    final URL = Strings.direccion + 'pedidos';
    final headers = {'Content-Type': 'application/json'};

    var id_empleado = txtEmpleado.text;
    var id_cliente = txtCliente.text;
    var id_producto = txtProducto.text;
    var cantidad = txtCantidad.text;
    var descuento = txtDescuento.text;

    DateTime fecha_pedido = new DateTime.now();
    DateTime fecha_envio = new DateTime(
      fecha_pedido.year,
      fecha_pedido.month,
      fecha_pedido.day,
      fecha_pedido.hour.toInt() + new Random().nextInt(24),
      fecha_pedido.minute.toInt() + new Random().nextInt(60),
      fecha_pedido.second.toInt() + new Random().nextInt(60),
      fecha_pedido.millisecond.toInt() + new Random().nextInt(1000),
    );

    Map<String, dynamic> body = {
      "fecha_pedido": fecha_pedido.toIso8601String(),
      "fecha_envio": fecha_envio.toIso8601String(),
      "id_cliente": {
        "id_cliente": int.parse(id_cliente)
      },
      "empleado": {
        "id_empleado": int.parse(id_empleado)
      }
    };

    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    var response = await http.post(
        URL,
        headers: headers,
        body: jsonBody,
        encoding: encoding
    );

    if(response.statusCode != 200)
      return response;

    var pedidoData = json.decode(response.body);

    var producto_compra_response = await http.get(
        Uri.encodeFull(Strings.direccion + "productos/" + id_producto.toString()),
        headers: {"Accept": "application/json"});

    var productoCompraData = json.decode(producto_compra_response.body);

    Map<String, dynamic> body_detalle = {
      "precio": productoCompraData[0]['precio'],
      "descuento": double.parse(descuento),
      "cantidad": double.parse(cantidad),
      "producto": {
        "id_producto": int.parse(id_producto)
      },
      "pedido": {
        "id_pedido": pedidoData['id_pedido']
      }
    };

    print(pedidoData['id_pedido']);

    String jsonBodyDetalle = json.encode(body_detalle);

    var responseDetalle = await http.post(
        Strings.direccion + 'detallepedido',
        headers: headers,
        body: jsonBodyDetalle,
        encoding: encoding
    );


    if(responseDetalle.statusCode != 200)
      return responseDetalle;

    Map<String, dynamic> body_producto = {
      "producto": productoCompraData[0]['producto'],
      "costo": productoCompraData[0]['costo'],
      "precio": productoCompraData[0]['precio'],
      "existencia": productoCompraData[0]['existencia'] - int.parse(cantidad),
      "reorden": productoCompraData[0]['reorden'],
      "comprometidas": productoCompraData[0]['comprometidas'],
      "vigente": productoCompraData[0]['vigente'],
      "imagen": productoCompraData[0]['imagen']
    };

    String jsonBodyProducto = json.encode(body_producto);

    var responseProducto = await http.put(
        Strings.direccion + 'productos/' + id_producto.toString(),
        headers: headers,
        body: jsonBodyProducto,
        encoding: encoding
    );

    return responseProducto;
  }
}

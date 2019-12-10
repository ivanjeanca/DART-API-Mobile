import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_wepapi/Strings.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<Login>{

  final txtUsuario = TextEditingController();
  final txtContrasena = TextEditingController();
  bool recordarLogin = false;

  LoginState () {
    checarLogueado();
  }

  checarLogueado() async{
    var logueado;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    logueado = prefs.getBool("logueado") ?? false;
    print("ira el logueao");
    print(logueado);
    if (logueado)
      Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {

    Future<http.Response> validateUser() async{
      var usr = txtUsuario.text;
      var pwd = txtContrasena.text;


      http.Response response = await http.get(
          Uri.encodeFull(Strings.direccion + "login/$usr/$pwd"),
          headers: { "Accept" : "application/json"}
      );

      return response;
    }

    Future<http.Response> userInfo() async{
      var usr = txtUsuario.text;

      http.Response response = await http.get(
          Uri.encodeFull(Strings.direccion + "usuarios/$usr"),
          headers: { "Accept" : "application/json"}
      );

      return response;
    }

    final logo = Hero(
      tag: 'Logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 75.0,
        //child: Image.network("http://i.pravatar.cc/300"),
        child: Image.network('http://storenyc.com/wp-content/uploads/2018/11/STORE-Logo.png'),
      ),
    );

    final indicaciones = Text(
      "Iniciar sesión",
      style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 30.0,
            color: Color.fromARGB(255, 33, 37, 41),
          ),
      textAlign: TextAlign.center,
    );

    final txtEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: txtUsuario,
      //autofocus: false,
      decoration: InputDecoration(
        hintText: 'Correo electrónico',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0),),
      ),
      cursorColor: Color.fromARGB(255, 0, 100, 150),
    );

    final txtPwd = TextFormField(
      controller: txtContrasena,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
      ),
    );

    final recordarInicioSesionTXT = Text(
      "Recordar inicio de sesión",
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 15.0,
        color: Color.fromARGB(255, 33, 37, 41),
      ),
    );

    final recordarInicioSesion = Checkbox(
      onChanged: (bool resp){
        setState(() {
          recordarLogin = resp;
        });
      },
      value: recordarLogin,
      activeColor: Color.fromARGB(255, 33, 37, 41),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        onPressed: () async {
          var codigo = await validateUser();
          //var codigo = 200;
          print(codigo.statusCode);
          if( codigo.statusCode == 200 ){
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            final loginData = json.decode(codigo.body);
            print(loginData.toString());
            print(loginData.toString().substring(17, 49));
            var usuario = await userInfo();
            final userData = json.decode(usuario.body);

            if(recordarLogin)
              prefs.setBool("logueado", true);
            else
              prefs.setBool("logueado", false);

            prefs.setString("token", loginData.toString().substring(17, 49));
            prefs.setInt("id_empleado", userData[0]['id']);
            prefs.setString("nombre", userData[0]['empleado']['nombre'] + " " + userData[0]['empleado']['apaterno'] + " " + userData[0]['empleado']['amaterno']);
            prefs.setString("correo", userData[0]['empleado']['correo']);

            Navigator.pushReplacementNamed(context, '/dashboard');
          }else{
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Inicio de sesión incorrecto"),
                  content: Text("El usuario y/o contraseña no son correctos"),
                  actions: <Widget>[
                    new FlatButton(
                      child: Text("Cerrar"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
            );
          }
        },
        padding: EdgeInsets.all(12),
        color: Color.fromARGB(255, 33, 37, 41),
        child: Text('Entrar', style: TextStyle(color: Colors.white, fontSize: 17)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 15.0),
            indicaciones,
            SizedBox(height: 15.0),
            txtEmail,
            SizedBox(height: 15.0),
            txtPwd,
            SizedBox(height: 15.0),
            new Row(
              children: <Widget>[
                recordarInicioSesion,
                recordarInicioSesionTXT
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            SizedBox(height: 15.0),
            loginButton
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MenuLateral();
  }
}

class MenuLateral extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuLateralState();
  }
}

class MenuLateralState extends State<MenuLateral>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tienda en línea"),
        backgroundColor: Color.fromARGB(255, 33, 37, 41),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 33, 37, 41),
              ),
              accountName: Text("Jeancarlo Tirado"),
              accountEmail: Text("15030104@itcelaya.edu.mx"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
              ),
            ),
            ListTile(
              title: Text("Ver áreas"),
              trailing: Icon(Icons.map),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/areas');
              },
            ),
            ListTile(
              title: Text("Ver áreas cliente"),
              trailing: Icon(Icons.account_box),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/areas-cliente');
              },
            ),
            ListTile(
              title: Text("Ver clientes"),
              trailing: Icon(Icons.contacts),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/clientes');
              },
            ),
            ListTile(
              title: Text("Ver detalle pedido"),
              trailing: Icon(Icons.event_note),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ctes');
              },
            ),
            ListTile(
              title: Text("Ver pedidos"),
              trailing: Icon(Icons.shop),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ctes');
              },
            ),
            ListTile(
              title: Text("Ver productos"),
              trailing: Icon(Icons.shopping_basket),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/productos');
              },
            ),
            ListTile(
              title: Text("Ver producto área cliente"),
              trailing: Icon(Icons.shopping_cart),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ctes');
              },
            ),
            ListTile(
              title: Text("Cerrar sesión"),
              trailing: Icon(Icons.exit_to_app),
              onTap: () async{
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("logueado", false);
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, 
                '/login',(Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
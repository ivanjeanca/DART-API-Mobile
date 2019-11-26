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
        title: Text("Dashboard EPP"),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent
              ),
              accountName: Text("Jeancarlo Tirado"),
              accountEmail: Text("15030104@itcelaya.edu.mx"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: new NetworkImage("http://i.pravatar.cc/300"),
              ),
            ),
            ListTile(
              title: Text("Clientes"),
              trailing: Icon(Icons.contacts),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/ctes');
              },
            ),
            ListTile(
              title: Text("Productos"),
              trailing: Icon(Icons.local_grocery_store),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/prod');
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>Productos()));
              },
            ),
            ListTile(
              title: Text("Salir"),
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
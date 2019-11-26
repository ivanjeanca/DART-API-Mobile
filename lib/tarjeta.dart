import 'package:flutter/material.dart';
import 'package:flutter_wepapi/models/productos.dart';

class Tarjeta extends StatelessWidget {
  DAOProductos productos;
  Tarjeta(this.productos);

  @override
  Widget build(BuildContext context) {
return new Card(
      child: new Column(
        children: <Widget>[
          new Image.network(productos.imagen, height: 200,),
          new Padding(
            padding: new EdgeInsets.all(7.0),
            child: new Row(
              children: <Widget>[
                new Text(
                  productos.producto,
                  style: new TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          new Padding(
            padding: new EdgeInsets.all(3.0),
            child: new Row(
              children: <Widget>[
                new Text(
                  "\$" + productos.precio.toString() + " mxn",
                  style: new TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 0, 100, 150),
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          new Padding(
            padding: new EdgeInsets.all(7.0),
            child: new Row(
              children: <Widget>[
               new Padding(
                 padding: new EdgeInsets.all(7.0),
                 child: new Icon(Icons.thumb_up),
               ),
               new Padding(
                 padding: new EdgeInsets.all(7.0),
                 child: new Text('Like',style: new TextStyle(fontSize: 18.0),),
               ),
               new Padding(
                 padding: new EdgeInsets.all(7.0),
                 child: new Icon(Icons.comment),
               ),
               new Padding(
                 padding: new EdgeInsets.all(7.0),
                 child: new Text('Comments',style: new TextStyle(fontSize: 18.0)),
               )


              ],
            )
          )
        ],
      ),
    );
  }
}
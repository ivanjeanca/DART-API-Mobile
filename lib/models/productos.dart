class DAOProductos{
  int id_producto;
  String producto;
  num costo;
  num precio;
  int existencia;
  int reorden;
  int comprometidas;
  bool vigente;
  String imagen;

  DAOProductos({this.id_producto,this.producto,this.costo,this.precio,this.existencia,this.reorden,this.comprometidas,this.vigente,this.imagen});

  factory DAOProductos.fromJson(Map json) {
    return DAOProductos(
      id_producto: json['id_producto'] as int,
      producto: json['producto'] as String,
      costo: json['costo'] as num,
      precio: json['precio'] as num,
      existencia: json['existencia'] as int,
      reorden: json['reorden'] as int,
      comprometidas: json['comprometidas'] as int,
      vigente: json['vigente'] as bool,
      imagen: json['imagen'] as String
    );
  }
}

class ListaProductos {
  List<DAOProductos> productos;
  ListaProductos({this.productos});

  factory ListaProductos.fromJson(List<dynamic> jsonList) {
    List<DAOProductos> productos = List<DAOProductos>();
    productos = jsonList.map((i) => DAOProductos.fromJson(i)).toList();
    return ListaProductos(productos: productos);
  }
}
class CatalogModel {
  String name = "";
  String description = "";
  double price = 0.0;
  String image = "";
  String proveedor = "";

  CatalogModel(name, description, price, image, proveedor) {
    this.name = name;
    this.description = description;
    this.price = price;
    this.image = image;
    this.proveedor = proveedor;
  }
}

class ProductServiceModel {
  String idProducto_Servicio = "";
  String name = "";
  String idProveedor = "";
  String proveedor = "";

  ProductServiceModel(idProducto_Servicio, name, idProveedor, proveedor) {
    this.idProducto_Servicio = idProducto_Servicio;
    this.name = name;
    this.idProveedor = idProveedor;
    this.proveedor = proveedor;
  }
}

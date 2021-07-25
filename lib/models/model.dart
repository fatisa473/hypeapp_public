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

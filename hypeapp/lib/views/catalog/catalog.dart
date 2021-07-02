import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//DIRECTORIO
import 'package:hypeapp/views/catalog/foundCatalog.dart';

// ignore: camel_case_types
class ProductsServicesCatalogPage extends StatefulWidget {
  _ProductsServicesCatalogState createState() =>
      _ProductsServicesCatalogState();
}

class _ProductsServicesCatalogState extends State<ProductsServicesCatalogPage> {
  int _totalPS = 3; //Contador del total de productos y servicios
  //int _totalPS = products.length;
  int _filtercount = 0; //Contador del filtro

  List<int> selectedIndexList = <int>[];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Filtro(_filtercount),
        Flexible(
          child: _buildGrid(),
        ),
      ],
    );
  }

  Widget _buildGrid() => GridView.builder(
        itemCount: _totalPS,
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            //color: Colors.red,
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (!selectedIndexList.contains(index)) {
                      selectedIndexList.add(index);
                      print("Seleccionado $index");
                    } else {
                      selectedIndexList.remove(index);
                      print("No Seleccionado $index");
                    }
                  },
                  child: Container(
                    width: 170,
                    height: 170,
                    //color: Colors.blue,
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.all(6),
                      child: Column(
                        children: [
                          new Center(
                            child: Image(
                              image: AssetImage("assets/background.png"),
                              width: 120.0,
                              height: 84.0,
                            ),
                          ),
                          new ListTile(
                            title: new Text(
                              "Producto: producto",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            subtitle: new Text(
                              'Descripcion: es un producto',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //
          );
        },
      );
}

class Filtro extends StatefulWidget {
  int _counter = 0;
  Filtro(this._counter);

  @override
  _FiltroState createState() => _FiltroState();
}

class _FiltroState extends State<Filtro> {
  // Default Radio Button Selected Item When App Starts.
  String filtroRadioButtonItem = 'ONE';

  // Group Value for Radio Button.
  int filtroId = 1;

  bool producto = false;
  bool servicio = false;

  int filtro_producto = 0;
  int filtro_servicio = 0;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actions: <Widget>[
              Container(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        //width: 320, //400,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              //color: Colors.red,
                              width: 150,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(
                                          value: 1,
                                          groupValue: filtroId,
                                          onChanged: (val) {
                                            setState(() {
                                              filtroRadioButtonItem = 'ONE';
                                              filtroId = 1;
                                            });
                                          },
                                        ),
                                        Text("A-Z"),
                                        Radio(
                                          value: 2,
                                          groupValue: filtroId,
                                          onChanged: (val) {
                                            setState(() {
                                              filtroRadioButtonItem = 'TWO';
                                              filtroId = 2;
                                            });
                                          },
                                        ),
                                        Text("Z-A"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Divider(color: Colors.blueGrey),
                            //
                            Container(
                              //color: Colors.red,
                              width: 172,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: filtro_producto,
                                        onChanged: (val) {
                                          setState(() {
                                            filtro_producto = 1;
                                          });
                                        },
                                      ),
                                      Text("Tipo - Productos"),
                                    ],
                                  ),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: 1,
                                        groupValue: filtro_servicio,
                                        onChanged: (val) {
                                          /*setState(() {
                                            filtro_servicio = 1;
                                          });*/
                                          if (filtro_servicio == 0) {
                                            setState(() {
                                              filtro_servicio = 1;
                                            });
                                          } else if (filtro_servicio == 1) {
                                            setState(() {
                                              filtro_servicio = 0;
                                            });
                                          }
                                        },
                                      ),
                                      Text("Tipo - Servicio"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop("Cancelar");
                    },
                  ),
                  FlatButton(
                    child: Text("Buscar"),
                    onPressed: () {
                      Navigator.of(context).pop("Buscar");
                    },
                  ),
                ],
              ),
              //
            ],
          );
        });
      },
    ).then(
      (value) {
        if (value != null) print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56, //85,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 2,
                left: 10,
                right: 10,
              ),
            ),
            Center(
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showDialog(); //_showPopup();
                },
                child: Container(
                  child: Icon(
                    Icons.filter_alt,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "${widget._counter} Resultados",
                          style: TextStyle(
                            color: const Color(0xffc4c2bf),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

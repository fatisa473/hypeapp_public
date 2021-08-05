import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hypeapp/models/model.dart';

//DIRECTORIO
import 'package:hypeapp/views/catalog/foundCatalog.dart';
import 'package:hypeapp/views/constants.dart';
import 'package:hypeapp/views/various.dart';

// ignore: camel_case_types
class ProductsServicesCatalogPage extends StatefulWidget {
  _ProductsServicesCatalogState createState() =>
      _ProductsServicesCatalogState();
}

class _ProductsServicesCatalogState extends State<ProductsServicesCatalogPage> {
  bool isSearch = false;
  bool isLoading = false;

  Icon actionIcon = new Icon(Icons.search);

  //FILTROS
  int filtroOrden = 1, filtroTipo = 3;
  String nombreOrden = "ASC", nombreTipo = "Todos";

//
  Map<String, String> controlFiltro = {
    "Orden": "1",
    "nombreOrden": "ASC",
    "Tipo": "3",
    "nombreTipo": "Todos"
  };

  TextEditingController buscar = new TextEditingController();

  int _totalPS = 0; //Contador del total de productos y servicios

  Future<void> getCatalog() async {
    try {
      var response = await http.post(Uri.parse(SERVIDOR), body: {
        "tipo": "busqueda",
        "filtro_tipo": nombreTipo,
        "orden": nombreOrden,
        "buscar": buscar.text,
      });

      if (!mounted) return;
      catalogo.clear();
      _totalPS = 0;

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);

        if (data['resp'] == "success") {
          _totalPS = data['body'].length;
          for (var item in data['body']) {
            catalogo.add(CatalogModel(
                item['nombre'],
                item['descripcion'],
                double.parse(item['precio']),
                IMGS + item['imagen'],
                item['nombres'] + " " + item['ap_pat'] + " " + item['ap_mat']));
          }
        } else if (data['resp'] == "fail") {
          messageSimple("No se ha encontrado coincidencias");
        }

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      messageSimple("Error: " + e.toString());
    }
  }

  @override
  void initState() {
    isLoading = true;
    buscar.text = "";
    getCatalog();
    super.initState();
  }

  Widget searchBarOpen() {
    return new Container(
      width: appBarTitle_AppBar,
      padding: EdgeInsets.all(18),
      child: Column(
        children: <Widget>[
          inputText(
              label: "Buscar Productos y Servicios", nameController: buscar),
        ],
      ),
    );
  }

//Barra de busqueda cerrado
  Widget searchBarClosed() {
    return new Text(
      ("Productos y Servicios"),
      style: TextStyle(
        fontSize: fontSize_AppBar,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: isSearch == true ? searchBarOpen() : searchBarClosed(),
        backgroundColor: bgColor_AppBar,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            tooltip: "Buscar",
            iconSize: iconSize_AppBar, //24,
            onPressed: () {
              if (actionIcon.icon == Icons.search) {
                setState(() {
                  actionIcon = new Icon(Icons.close);
                  isSearch = true;
                });
              } else {
                setState(() {
                  actionIcon = new Icon(Icons.search);
                  buscar.text = "";
                  isSearch = false;
                });
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? LoadingFull()
          : Column(
              children: <Widget>[
                mostrarFiltro(),
                Flexible(
                  child: _buildGrid(),
                ),
              ],
            ),
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
                    print("Seleccionado $index");
                    Get.to(() => FoundCatalogoTile(index));
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
                            child: Image.network(
                              catalogo[index].image,
                              width: 120.0,
                              height: 84.0,
                            ),
                          ),
                          new ListTile(
                            title: new Text(
                              "Producto: " + catalogo[index].name,
                              style: TextStyle(
                                fontSize: 14,
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

  Widget mostrarFiltro() {
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
                  filtro();
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
                          "${_totalPS} Resultados",
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

  void filtro() {
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
                                          groupValue: filtroOrden,
                                          onChanged: (val) {
                                            setState(() {
                                              filtroOrden = 1;
                                              nombreOrden = "ASC";
                                            });
                                          },
                                        ),
                                        Text("A-Z"),
                                        Radio(
                                          value: 2,
                                          groupValue: filtroOrden,
                                          onChanged: (val) {
                                            setState(() {
                                              filtroOrden = 2;
                                              nombreOrden = "DESC";
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
                                        groupValue: filtroTipo,
                                        onChanged: (val) {
                                          setState(() {
                                            filtroTipo = 1;
                                            nombreTipo = "Producto";
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
                                        value: 2,
                                        groupValue: filtroTipo,
                                        onChanged: (val) {
                                          setState(() {
                                            filtroTipo = 2;
                                            nombreTipo = "Servicio";
                                          });
                                        },
                                      ),
                                      Text("Tipo - Servicios"),
                                    ],
                                  ),
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: 3,
                                        groupValue: filtroTipo,
                                        onChanged: (val) {
                                          setState(() {
                                            filtroTipo = 3;
                                            nombreTipo = "Todos";
                                          });
                                        },
                                      ),
                                      Text("Tipo - Todos"),
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
                  TextButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      setState(() {
                        filtroOrden = int.parse(controlFiltro["Orden"]!);
                        nombreOrden = controlFiltro["nombreOrden"]!;
                        filtroTipo = int.parse(controlFiltro["Tipo"]!);
                        nombreTipo = controlFiltro["nombreTipo"]!;
                      });
                      Get.back();
                    },
                  ),
                  TextButton(
                    child: Text("Buscar"),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        controlFiltro["Orden"] = filtroOrden.toString();
                        controlFiltro["nombreOrden"] = nombreOrden;
                        controlFiltro["Tipo"] = filtroTipo.toString();
                        controlFiltro["nombreTipo"] = nombreTipo;
                      });
                      getCatalog();
                      Get.back();
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

  Widget inputText({label, nameController, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 2,
        ),
        TextField(
          /* onChanged: (val) {
          },*/
          onSubmitted: (val) {
            isLoading = true;
            getCatalog();
          },
          controller: nameController,
          maxLines: 1,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: fillColorTextField_AppBar,
            hintText: label,
            hintStyle: TextStyle(
              fontSize: 13, //15
            ),
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderSideColor_AppBar,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderSideColor_AppBar,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

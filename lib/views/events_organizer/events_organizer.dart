import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hypeapp/views/constants.dart';

//DIRECTORIO
import 'crud_event_organizer.dart';
import 'found_event_organizar.dart';

class EventsOrganizerPage extends StatefulWidget {
  _EventsOrganizerPage createState() => _EventsOrganizerPage();
}

class _EventsOrganizerPage extends State<EventsOrganizerPage> {
  final box = GetStorage();

  Future<List> getDataEvent() async {
    final response = await http.post(
        Uri.parse("https://hypeapp1.herokuapp.com/getdataevent.php"),
        body: {'email': box.read("email")});
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: new Text(
            ("Eventos"),
            style: TextStyle(
              fontSize: fontSize_AppBar,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: bgColor_AppBar,
        ),
        body: Stack(
          children: [
            FutureBuilder<List>(
              future: getDataEvent(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? new ItemList(
                        list: snapshot.data!,
                      )
                    : new Center(
                        child: new CircularProgressIndicator(),
                      );
              },
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),
                child: MaterialButton(
                  minWidth: 300.0,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AgregarEventosOrganizerPage()),
                    );
                  },
                  color: Color(0xff08497F),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Agregar",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({required this.list});

  int _totalPS = 10; //Contador del total de productos y servicios
  //int _totalPS = products.length;
  int _filtercount = 0; //Contador del filtro

  List<int> selectedIndexList = <int>[];
  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
        itemCount: list == null ? 0 : list.length,
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
        ),
        itemBuilder: (context, i) {
          return Container(
            //color: Colors.red,
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (!selectedIndexList.contains(i) ||
                        selectedIndexList.contains(i)) {
                      selectedIndexList.add(i);
                      print("Seleccionado $i");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FoundEventoOrganizerTile(list: list, index: i),
                        ),
                      );
                    }
                    /*else {
                      selectedIndexList.remove(index);
                      print("No Seleccionado $index");
                    }*/
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.15,
                    //color: Colors.blue,
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.all(6),
                      child: Column(
                        children: [
                          Text(
                            list[i]["nombre"],
                          ),
                          new ListTile(
                            title: new Text(
                              list[i]["fecha"] + " " + list[i]["hor_inicial"],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            subtitle: new Text(
                              list[i]["locacion_resp"],
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
        });
  }
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

Widget buttonAdd() {
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 3, left: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border(
              bottom: BorderSide(color: Colors.black),
              top: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
            )),
        child: MaterialButton(
          minWidth: double.infinity,
          height: 60,
          onPressed: () {},
          color: Color(0xff08497F),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            "Agregar",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}

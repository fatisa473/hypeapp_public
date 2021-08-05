import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
//import 'dart:js' show context;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../organizer.dart';
import '../various.dart';
import 'editar_event_organizer.dart';

class FoundEventoOrganizerTile extends StatefulWidget {
  List list;
  int index;

  FoundEventoOrganizerTile({required this.list, required this.index});

  @override
  _FoundEventoOrganizerTile createState() => _FoundEventoOrganizerTile();
}

class _FoundEventoOrganizerTile extends State<FoundEventoOrganizerTile> {
  //fecha
  var _currentselectDate;

  var imagePath;
  //LOADING
  bool _loading = false;
  //VALIDACION
  final _formKey = new GlobalKey<FormState>();

  //deleteFunction
  void deleteData() {
    var url = Uri.parse(
        "https://hypeapp1.herokuapp.com/eventsproducts_php/deletedataevent.php");
    http.post(url, body: {
      'idEvento': widget.list[widget.index]['idEvento'],
    });
  }

  //functionConfirm
  void Confirmar() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text(
          "Seguro que desea eliminar '${widget.list[widget.index]['nombre']}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "Eliminar!",
            style: TextStyle(color: Colors.blue),
          ),
          color: Colors.white,
          onPressed: () {
            deleteData();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrganizerPage(
                        //id: "1",
                        )));
          },
        ),
        new RaisedButton(
          child: new Text(
            "Cancelar.",
            style: TextStyle(color: Colors.blue),
          ),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  //SELECT   - - - - - - - - - - - -   Verificar consulta
  Map<String, String> nacionalidadesMap = {}, perfilesMap = {};
  //funcion fecha
  void callDatePicker() async {
    var selectDate = await getDatePickerWidget(context);
    setState(() {
      _currentselectDate = selectDate;
    });
  }

  Future<DateTime?> getDatePickerWidget(context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime(2021),
      firstDate: DateTime(2021),
      lastDate: DateTime(2023),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "${widget.list[widget.index]['nombre']}",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Hype App",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    inputFile(
                        label: "Nombre",
                        nameController: eventoNombre
                          ..text = widget.list[widget.index]
                              ['nombre'], //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Tipo de evento",
                        nameController: eventoCategoria
                          ..text = widget.list[widget.index]
                              ['idTipo_Evento'], //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Fecha",
                        nameController: eventoFecha
                          ..text = widget.list[widget.index]
                              ['fecha'], //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Hora inicial",
                        nameController: eventoHoraInicio
                          ..text = widget.list[widget.index]
                              ['hor_inicial'], //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Hora Final",
                        nameController: eventoHoraFinal
                          ..text = widget.list[widget.index]
                              ['hor_final'], //Confirmar nombre del campo
                        maxLength: "40"),
                    inputMap(
                        label: "Locacion",
                        nameController: eventoLocacion
                          ..text = widget.list[widget.index]
                              ['locacion'], //Confirmar nombre del campo
                        maxLength: "40",
                        controltext: eventoLocacion.text),
                    inputMap(
                        label: "Locacion de respaldo",
                        nameController: eventoLocacionRespaldo
                          ..text = widget.list[widget.index]
                              ['locacion_resp'], //Confirmar nombre del campo
                        maxLength: "40",
                        controltext: eventoLocacionRespaldo.text),
                    inputFile(
                        label: "Descripcion",
                        nameController: eventoDescripcion
                          ..text = widget.list[widget.index]
                              ['descripcion'], //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Numero de banquetes",
                        nameController: eventoBanquetes
                          ..text = "3", //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Nombre del banquete",
                        nameController: eventoTipoBanquetes
                          ..text =
                              "Banquetes dos soles", //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Productos y servicios",
                        nameController: eventoProductoServicio
                          ..text = "producto1", //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Tipo",
                        nameController: eventoTipoProductoServicio
                          ..text = "1", //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Producto o servicio",
                        nameController: eventoProductoOServicio
                          ..text = "producto", //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Informacion extra",
                        nameController: eventoInformacionExtra
                          ..text =
                              "Entrar al primer camino de terraceria para llegar a la locacion", //Confirmar nombre del campo
                        maxLength: "255"),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    ),
                    new Column(
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
                            onPressed: () => Navigator.of(context)
                                .push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  EditarEventosOrganizerPage(
                                list: widget.list,
                                index: widget.index,
                              ),
                            )),
                            color: Color(0xffFF9400),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Editar",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                        ),
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
                            onPressed: () => Confirmar(),
                            color: Color(0xffFF1300),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Eliminar",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]))
            ])));
  }

  Widget inputFile(
      {label, obscureText = false, nameController, maxLength = "16", text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          readOnly: true,
          controller: nameController,
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!))),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget inputMap({
    label,
    obscureText = false,
    nameController,
    maxLength = "16",
    controltext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          onTap: () {},
          readOnly: true,
          controller: nameController,
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!))),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

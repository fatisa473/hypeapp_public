import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

import '../supplier.dart';
import '../various.dart';
import 'edit_catalog_supplier.dart';

class FoundCatalogoTile extends StatefulWidget {
  List list;
  int index;

  FoundCatalogoTile({required this.list, required this.index});

  @override
  _FoundCatalogoTile createState() => _FoundCatalogoTile();
}

class _FoundCatalogoTile extends State<FoundCatalogoTile> {
  var imagePath;
  //LOADING
  bool _loading = false;
  //VALIDACION
  final _formKey = new GlobalKey<FormState>();

  //SELECT   - - - - - - - - - - - -   Verificar consulta
  Map<String, String> nacionalidadesMap = {}, perfilesMap = {};

  //deleteFunction
  void deleteData() {
    var url = Uri.parse(
        "https://hypeapp1.herokuapp.com/eventsproducts_php/deletedataproduct.php");
    http.post(url,
        body: {'idProducto': widget.list[widget.index]['idProducto_Servicio']});
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
                    builder: (context) => SupplierPage(
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

  Map<String, String> tipo = {
    "1": "Producto",
    "2": "Servicio",
  };

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
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "Nombre del Producto o Servicio",
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
              child: Column(
                children: <Widget>[
                  inputFile(
                      label: "Nombre",
                      nameController: productoNombre
                        ..text = widget.list[widget.index]
                            ['nombre'], //Confirmar nombre del campo
                      maxLength: "40"),
                  inputFile(
                      label: "Categoria",
                      nameController: productoCategoria
                        ..text = widget.list[widget.index]
                            ['idTipo'], //Confirmar nombre del campo
                      maxLength: "40"),
                  inputFile(
                      label: "Precio",
                      nameController: productoPrecio
                        ..text = widget.list[widget.index]
                            ['precio'], //Confirmar nombre del campo
                      maxLength: "40"),
                  //Se agrega un TextField para poder
                  //tener la opcion multilinea
                  Text("Descripción:"),
                  TextField(
                    readOnly: true,
                    controller: productoDescripcion
                      ..text = widget.list[widget.index]['descripcion'],
                    maxLength: 200,
                    keyboardType: TextInputType.multiline,
                    //Nombre de controlador pendiente
                  ),
                  Text("Cambiar imagen"),
                  (imagePath == null)
                      ? Container()
                      : Image.file(File(imagePath)),
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      PickedFile? _pickedFile =
                          await _picker.getImage(source: ImageSource.gallery);
                      imagePath = _pickedFile!.path;
                      setState(() {});
                    },
                    child: Text("Examinar..."),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Column(
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
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditarProductosServicesPage(
                                list: widget.list,
                                index: widget.index,
                              )));
                    },
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
            ),
            Column(
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
                    onPressed: () {
                      Confirmar();
                    },
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
            )
          ],
        ),
      ),
    );
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

  Widget dropdownCategoria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Categoria",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(height: 5),
        DropdownSearch<String>(
          mode: Mode.MENU,
          enabled: _loading == false ? true : false,
          showSelectedItem: true,
          items: tipo.values.toList(),
          hint: "Seleccionar Categoria",
          selectedItem: widget.list[widget.index]['idTipo'],
          onChanged: (data) {
            productoCategoria.text = data.toString();
          },
          validator: (item) {
            return validarDropDown(item);
          },
          dropdownSearchDecoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!))),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

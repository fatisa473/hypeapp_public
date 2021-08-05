import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

//DIRECTORIO
import '../supplier.dart';
import '../various.dart';

class EditarProductosServicesPage extends StatefulWidget {
  List list;
  int index;

  EditarProductosServicesPage({required this.list, required this.index});
  _EditarProductosServicesPage createState() => _EditarProductosServicesPage();
}

class _EditarProductosServicesPage extends State<EditarProductosServicesPage> {
  var imagePath;
  //LOADING
  bool _loading = false;
  //VALIDACION
  final _formKey = new GlobalKey<FormState>();

  //SELECT   - - - - - - - - - - - -   Verificar consulta
  Map<String, String> nacionalidadesMap = {},
      perfilesMap = {},
      tipo = {
        "1": "Producto",
        "2": "Servicio",
      };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //limpiarControllers();
    super.dispose();
  }

  void editData() {
    var url = Uri.parse(
        "https://hypeapp1.herokuapp.com/eventsproducts_php/editproduct.php");
    http.post(url, body: {
      "id": widget.list[widget.index]['idProducto_Servicio'],
      "tipo": productoCategoria.text,
      "nombre": productoNombre.text,
      "descripcion": productoDescripcion.text,
      "imagen": productoImagen.text,
      "precio": productoPrecio.text,
    });
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Editar Producto",
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
                    dropdownCategoria(),
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
                    Text("Agregar imagen"),
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
              buttons(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttons() {
    return _loading == false ? buttonAdd() : loadingSimple();
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
            onPressed: () {
              editData();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SupplierPage()));
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

  Widget dropdownPerfil() {
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
          enabled: _loading == false ? true : false,
          mode: Mode.MENU,
          showSelectedItem: true,
          items: perfilesMap.values.toList(),
          hint: "Seleccionar Categoria",
          onChanged: (data) {
            perfilController.text = data.toString();
          },
          validator: (value) {
            return validarDropDown(value);
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

  Widget inputFile(
      {label, obscureText = false, nameController, maxLength = "16"}) {
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
          readOnly: _loading == false ? false : true,
          controller: nameController,
          obscureText: obscureText,
          validator: (item) {
            switch (label) {
              case "Nombre":
              case "Precio":
              case "Descripción":
              case "Agregar imagen":
            }
          },
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

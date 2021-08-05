import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';

//DIRECTORIO
import '../supplier.dart';
import '../various.dart';

class AgregarEventosPage extends StatefulWidget {
  _AgregarEventosPage createState() => _AgregarEventosPage();
}

class _AgregarEventosPage extends State<AgregarEventosPage> {
  //controladores
  TextEditingController controlNombreEvento = new TextEditingController();

  var imagePath;
  //LOADING
  bool _loading = false;
  //VALIDACION
  final _formKey = new GlobalKey<FormState>();

  //addFunction
  void addData() {
    var url = Uri.parse(
        "https://hypeapp1.herokuapp.com/eventsproducts_php/addevent.php");
    http.post(url, body: {
      "nombre": eventoNombre.text,
      "tipo_evento": eventoCategoria.text,
      "fecha": eventoFecha.text,
      "hora_ini": eventoHoraInicio.text,
      "hora_fin": eventoHoraFinal.text,
      "locacion": eventoLocacion.text,
      "locacion_resp": eventoLocacionRespaldo.text,
      "descripcion": eventoDescripcion.text,
      "num_banquete": eventoBanquetes.text,
      "nom_banquete": eventoTipoBanquetes.text,
      "num_productoservicio": eventoProductoServicio.text,
      "tipo_productoservicio": eventoTipoProductoServicio.text,
      "productoservicio": eventoProductoOServicio.text,
      "info_extra": eventoInformacionExtra.text,
    });
  }

  //SELECT   - - - - - - - - - - - -   Verificar consulta
  Map<String, String> nacionalidadesMap = {},
      perfilesMap = {},
      categoria = {
        "1": "Social",
        "2": "Empresarial",
        "3": "Otro",
      };

  @override
  void initState() {
    limpiarControllers();
    super.initState();
  }

  @override
  void dispose() {
    //limpiarControllers();
    super.dispose();
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
                    "Agregar Nuevo Evento",
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
                        hint: "Escribe un nombre de evento",
                        nameController:
                            eventoNombre, //Confirmar nombre del campo
                        maxLength: "40"),
                    dropdownCategoria(),
                    inputFile(
                        label: "Fecha",
                        hint: "AAAA-MM-DD",
                        nameController:
                            eventoFecha, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Hora inicial",
                        hint: "Ingresa una hora inicial",
                        nameController:
                            eventoHoraInicio, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Hora Final",
                        hint: "ingrese una hora final",
                        nameController:
                            eventoHoraFinal, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Locacion",
                        hint: "ingrese una ubicacion",
                        nameController:
                            eventoLocacion, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Locacion de respaldo",
                        hint: "Ingrese una ubicacion de respaldo",
                        nameController:
                            eventoLocacionRespaldo, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Descripcion",
                        hint: "Ingrese una descripcion",
                        nameController:
                            eventoDescripcion, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Numero de banquetes",
                        hint: "Ingrese un numero de banquetes",
                        nameController:
                            eventoBanquetes, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Nombre del banquete",
                        nameController:
                            eventoTipoBanquetes, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Productos y servicios",
                        hint: "Ingrese un numero de productos y servicios",
                        nameController:
                            eventoProductoServicio, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Tipo",
                        nameController:
                            eventoTipoProductoServicio, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Producto o servicio",
                        nameController:
                            eventoProductoOServicio, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Informacion extra",
                        hint: "Informacion que podria ser de utilidad conocer",
                        nameController:
                            eventoInformacionExtra, //Confirmar nombre del campo
                        maxLength: "255"),
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
              addData();
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

  Widget mapa() {
    LatLng cor = LatLng(37.4275, -122.1472);
    CameraPosition camera = new CameraPosition(target: cor);
    return GoogleMap(initialCameraPosition: camera);
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
          items: categoria.values.toList(),
          hint: "Seleccionar Categoria",
          onChanged: (data) {
            nacionalidadController.text = data.toString();
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

  Widget dropdownPerfil({nameController}) {
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
      {label, obscureText = false, nameController, maxLength = "16", hint}) {
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
            if (item!.isEmpty) return hint;
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

  Widget inputMap(
      {label, obscureText = false, nameController, maxLength = "16", hint}) {
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
            if (item!.isEmpty) return hint;
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

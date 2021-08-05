import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hypeapp/models/model.dart';
import 'package:hypeapp/views/constants.dart';
import 'package:image_picker/image_picker.dart';

//DIRECTORIO
import '../organizer.dart';
import '../various.dart';

class AgregarEventosOrganizerPage extends StatefulWidget {
  _AgregarEventosOrganizerPage createState() => _AgregarEventosOrganizerPage();
}

class _AgregarEventosOrganizerPage extends State<AgregarEventosOrganizerPage> {
  //controladores
  TextEditingController controlNombreEvento = new TextEditingController();

  var imagePath;
  //LOADING
  bool _loading = false;
  //VALIDACION
  final _formKey = new GlobalKey<FormState>();

  final box = GetStorage();

  //SELECT   - - - - - - - - - - - -   Verificar consulta
  Map<String, String> categoria = {},
      tipo_catalogo = {},
      nombres_banquetes = {};

  Future<void> getTipos() async {
    var response =
        await http.post(Uri.parse(SERVIDOR), body: {"tipo": "tipos_catalogo"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["resp"] == "Success") {
        setState(() {
          data["body"].forEach((key, value) {
            tipo_catalogo[key] = value;
          });
        });
      }
    }
  }

  Future<void> getTiposEventos() async {
    var response =
        await http.post(Uri.parse(SERVIDOR), body: {"tipo": "tipos_eventos"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["resp"] == "Success") {
        setState(() {
          data["body"].forEach((key, value) {
            categoria[key] = value;
          });
        });
      }
    }
  }

  Future<void> getBanquetes() async {
    var response =
        await http.post(Uri.parse(SERVIDOR), body: {"tipo": "banquetes"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["resp"] == "Success") {
        setState(() {
          data["body"].forEach((key, value) {
            nombres_banquetes[key] = value;
          });
        });
      }
    }
  }

  List<ProductServiceModel> productServices = [];
  List<String> productsservicesList = [];

  Future<void> getCatalogoProductosServicios() async {
    String tipo = "";
    tipo_catalogo.forEach((key, value) {
      if (value == eventoTipoProductoServicio.text) {
        setState(() {
          tipo = key;
        });
      }
    });

    var response = await http.post(Uri.parse(SERVIDOR),
        body: {"tipo": "productos_servicios", "idTipo": tipo});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      productServices.clear();
      productsservicesList.clear();
      if (data["resp"] == "Success") {
        setState(() {
          for (var item in data['body']) {
            productServices.add(ProductServiceModel(
                item['idProducto_Servicio'],
                item['nombre'],
                item['idDato'],
                item['nombres'] + " " + item['ap_pat'] + " " + item['ap_mat']));
          }
          for (var i = 0; i < productServices.length; i++) {
            productsservicesList.add(
                productServices[i].name + " - " + productServices[i].proveedor);
          }
        });
      }
    }
  }

  //addFunction
  void addData() async {
    String idTipoEvento = "",
        idNombBanquete = "",
        numProveedor = "",
        numProductoServicio = "";
    categoria.forEach((key, value) {
      if (value == eventoCategoria.text) {
        setState(() {
          idTipoEvento = key;
        });
      }
    });

    nombres_banquetes.forEach((key, value) {
      if (value == eventoTipoBanquetes.text) {
        setState(() {
          idNombBanquete = key;
        });
      }
    });

    for (var i = 0; i < productsservicesList.length; i++) {
      if (productsservicesList[i] == eventoProductoOServicio.text) {
        setState(() {
          numProveedor = productServices[i].idProveedor;
          numProductoServicio = productServices[i].idProducto_Servicio;
        });

        i = productsservicesList.length + 1;
      }
    }
    String email = box.read("email");
    String nombre_evento = eventoNombre.text;
    String fecha = eventoFecha.text;
    String hora_inicial = eventoHoraInicio.text;
    String hora_final = eventoHoraFinal.text;
    String locacion = eventoLocacion.text;
    String respaldo = eventoLocacionRespaldo.text;
    String descripcion = eventoDescripcion.text;
    String extra = eventoInformacionExtra.text;
    String consulta = "agregar_evento";

    var response = await http.post(
        Uri.parse("https://hypeapp1.herokuapp.com/basic_controller.php"),
        body: {
          "tipo": consulta,
          "email": email,
          "nombre": nombre_evento,
          "tipo_evento": idTipoEvento,
          "fecha": fecha,
          "hora_ini": hora_inicial,
          "hora_fin": hora_final,
          "locacion": locacion,
          "locacion_resp": respaldo,
          "descripcion": descripcion,
          "nom_banquete": idNombBanquete,
          "num_proveedor": numProveedor,
          "productoservicio": numProductoServicio,
          "info_extra": extra
        });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      if (data['resp'] == "Success") {
        messageSimple("Se ha agregado el evento correctamente");
        Get.back();
      }
    }
  }

  @override
  void initState() {
    getTiposEventos();
    getBanquetes();
    getTipos();
    limpiarControllers();
    super.initState();
  }

  @override
  void dispose() {
    limpiarControllers();
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
                    banquetes(),
                    inputFile(
                        label: "Productos y servicios",
                        hint: "Ingrese un numero de productos y servicios",
                        nameController:
                            eventoProductoServicio, //Confirmar nombre del campo
                        maxLength: "40"),
                    dropdowns(),
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
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrganizerPage()));*/
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
            eventoCategoria.text = data.toString();
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

  Widget banquetes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Nombre del banquete",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(height: 5),
        DropdownSearch<String>(
          mode: Mode.MENU,
          enabled: _loading == false ? true : false,
          showSelectedItem: true,
          items: nombres_banquetes.values.toList(),
          hint: "Seleccionar banquete",
          onChanged: (data) {
            eventoTipoBanquetes.text = data.toString();
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

  Widget dropdowns() {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Tipo",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            SizedBox(height: 5),
            DropdownSearch<String>(
              //enabled: visualizar == false ? false : true,
              mode: Mode.MENU,
              showSelectedItem: true,
              items: tipo_catalogo.values.toList(),
              hint: "Seleccionar tipo",
              onChanged: (data) {
                setState(() {
                  eventoTipoProductoServicio.text = data.toString();
                });
                getCatalogoProductosServicios();
              },
              validator: (item) {
                return validarDropDown(item);
              },
              dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!))),
            ),
            SizedBox(height: 10),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Catalogo",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            SizedBox(height: 5),
            DropdownSearch<String>(
              // enabled: visualizar == false ? false : true
              mode: Mode.MENU,
              showSelectedItem: true,
              items: productsservicesList.toList(),
              hint: "Seleccionar uno",
              onChanged: (data) {
                setState(() {
                  eventoProductoOServicio.text = data.toString();
                  print(eventoProductoOServicio.text);
                });
              },
              validator: (item) {
                return validarDropDown(item);
              },
              dropdownSearchDecoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[400]!))),
            ),
            SizedBox(height: 10),
          ],
        ),
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
          // readOnly: _loading == false ? false : true,
          controller: nameController,
          obscureText: obscureText,
          /*validator: (item) {
            if (item!.isEmpty) return hint;
          },*/
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hypeapp/views/constants.dart';

import 'package:hypeapp/views/information/edit_password.dart';
import 'package:hypeapp/views/various.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

class EditInfoPage extends StatefulWidget {
  const EditInfoPage({Key? key}) : super(key: key);

  @override
  _EditInfoPageState createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  @override
  void initState() {
    _loadingFull = true;
    super.initState();
    nacionalidades();
  }

  @override
  void dispose() {
    limpiarControllers();
    super.dispose();
  }

  //LOADING
  bool _loadingFull = false; //pantalla completa
  bool _informacionConseguida = false;

  //VALIDACION
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();

  //SELECT
  bool visualizar = false;
  Map<String, String> nacionalidadesMap = {};
  String cambio = "Ninguno";

  Map<String, String> informacionInicial = {};
  List<String> estatusList = ["Activo", "Pausado"];

  Future nacionalidades() async {
    var response = await http.post(
      Uri.parse(SERVIDOR),
      body: {"tipo": "nacionalidades"},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["resp"] == "Success") {
        setState(() {
          data["body"].forEach((key, value) {
            nacionalidadesMap[key] = value;
          });
        });
        getInformacion();
      } else if (data["resp"] == "fail") {
        _informacionConseguida = false;
      }
    } else {
      messageSimple("No se ha podido realizar la conexion");
      _informacionConseguida = false;
    }
  }

  Future getInformacion() async {
    var response = await http.post(
      Uri.parse(SERVIDOR),
      body: {"tipo": "visualizar informacion", "email": box.read("email")},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //
      setState(() {
        nameController.text = data['nombres'];
        paternoController.text = data['ap_pat'];
        maternoController.text = data['ap_mat'];
        telController.text = data['tel'];
        emailController.text = data['email'];
        empresaController.text = data['empresa'];

        informacionInicial['idNacionalidad'] = data['idNacionalidad'];
        informacionInicial['nombres'] = data['nombres'];
        informacionInicial['paterno'] = data['ap_pat'];
        informacionInicial['materno'] = data['ap_mat'];
        informacionInicial['tel'] = data['tel'];
        informacionInicial['email'] = data['email'];
        informacionInicial['empresa'] = data['empresa'];
        informacionInicial['estatus'] = data['estatus'];
        visualizar = false;
        _loadingFull = false;
        _informacionConseguida = true;
        cambio = "Ninguno";
      });
    } else {
      _informacionConseguida = false;
    }
  }

  Future revisarUsuario() async {
    var response = await http.post(Uri.parse(SERVIDOR), body: {
      "tipo": "revisar proveedor",
      "email": informacionInicial["email"]
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["resp"] == "success") {
        setInformacion();
      } else if (data["resp"] == "fail") {
        String message = "";
        switch (data["body"]) {
          case "351":
            message = "Asegurese de que no exista alguna actividad activa";
            break;
          default:
            message = "No se ha podido llevar a cabo la operación";
            break;
        }
        messageSimple(message);
        setState(() {
          _loadingFull = false;
        });
      }
    } else {
      messageSimple("No se ha podido realizar la conexion");
      setState(() {
        _loadingFull = false;
      });
    }
  }

  Future setInformacion() async {
    nacionalidadesMap.forEach((key, value) {
      if (value == nacionalidadController.text) {
        nacionalidadController.text = key;
      }
    });
    var response = await http.post(Uri.parse(SERVIDOR), body: {
      "tipo": "editar informacion",
      "nombres": nameController.text,
      "ap_pat": paternoController.text,
      "ap_mat": maternoController.text,
      "email_anterior": informacionInicial['email'],
      "email_nuevo": emailController.text,
      "empresa": empresaController.text,
      "tel": telController.text,
      "nacionalidad": nacionalidadController.text,
      "estatus": estatusController.text
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      if (data["resp"] == "success") {
        messageSimple("Se ha guardado correctamente");
        setState(() {
          _loadingFull = false;
        });
        if (cambio == "Dos" || cambio == "Estatus" || cambio == "Email") {
          logOut(context);
        } else {
          getInformacion();
        }
      } else if (data["resp"] == "fail") {
        String message = "";
        switch (data["body"]) {
          case "495":
            message = "No se ha podido guardar";
            break;
          default:
            message = "No se ha podido llevar a cabo la operación";
            break;
        }
        messageSimple(message);
        setState(() {
          _loadingFull = false;
        });
      }
    } else {
      messageSimple("No se ha podido realizar la conexion");
      setState(() {
        _loadingFull = false;
      });
    }
  }

//CERRAR SESION
  Future logOut(BuildContext context) async {
    limpiarControllers();
    messageSimple("Se ha cerrado sesion");
    Get.offNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    return _loadingFull
        ? WillPopScope(onWillPop: () async => false, child: LoadingFull())
        : _informacionConseguida
            ? Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: new Text(
                    ("Información"),
                    style: TextStyle(
                      fontSize: fontSize_AppBar,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: bgColor_AppBar,
                ),
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    height: MediaQuery.of(context).size.height - 50,
                    width: double.infinity,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Hype App",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            )
                          ],
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              inputFile(
                                  label: "Nombres",
                                  nameController: nameController,
                                  maxLength: "80"),
                              inputFile(
                                  label: "Apellido Paterno",
                                  nameController: paternoController,
                                  maxLength: "40"),
                              inputFile(
                                  label: "Apellido Materno",
                                  nameController: maternoController,
                                  maxLength: "40"),
                              inputFile(
                                  label: "Correo electrónico",
                                  nameController: emailController,
                                  maxLength: "50"),
                              dropdowns(),
                              inputFile(
                                  label: "Empresa",
                                  nameController: empresaController,
                                  maxLength: "50"),
                              inputFile(
                                  label: "Teléfono",
                                  nameController: telController,
                                  maxLength: "10"),
                            ],
                          ),
                        ),
                        buttons(),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Text("La información no se ha podido cargar"),
              );
  }

  Widget buttons() {
    return visualizar == false ? buttonActions() : buttonEdits();
  }

  Widget buttonActions() {
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
          child: Column(
            children: <Widget>[
              // the login button
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditingPasswordPage()),
                  );
                },
                color: Color(0xffFF9400),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Editar Contraseña",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
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
          child: Column(
            children: <Widget>[
              // the login button
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  setState(() {
                    nacionalidadController.text =
                        nacionalidadesMap[informacionInicial['idNacionalidad']]
                            .toString();
                    estatusController.text =
                        informacionInicial['estatus'].toString();
                    visualizar = true;
                  });
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
            ],
          ),
        ),
        SizedBox(height: 5),
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
          child: Column(
            children: <Widget>[
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  logOut(context);
                },
                color: Color(0xffFF4638),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget buttonEdits() {
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
            ),
          ),
          child: Column(
            children: <Widget>[
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  //guardar
                  if (emailController.text != informacionInicial["email"] &&
                      estatusController.text != informacionInicial["estatus"]) {
                    _mostrarAlerta(
                        context,
                        "¿Estas seguro de cambiar correo y estatus?",
                        "Asegurese de no tener ninguna actividad activa y seras redirigido al home",
                        "Dos");
                  } else if (emailController.text !=
                      informacionInicial["email"]) {
                    cambio = "email";
                    _mostrarAlerta(
                        context,
                        "¿Estas seguro de cambiar el correo electronico?",
                        "Seras redirigido al home",
                        "Email");
                  } else if (estatusController.text == "Pausado") {
                    _mostrarAlerta(
                        context,
                        "¿Estas seguro de cambiar estatus?",
                        "Asegurese de no tener ninguna actividad activa y seras redirigido al home",
                        "Estatus");
                  } else {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        cambio = "Ninguno";
                        _loadingFull = true;
                      });
                      setInformacion();
                    }
                  }
                },
                color: Color(0xff00C322),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Guardar",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
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
          child: Column(
            children: <Widget>[
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  informacionResetear();
                  setState(() {
                    visualizar = false;
                    FocusScope.of(context).unfocus();
                    formKey.currentState!.reset();
                  });
                },
                color: Color(0xffFF4638),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
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
              "Nacionalidad",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            SizedBox(height: 5),
            DropdownSearch<String>(
              enabled: visualizar == false ? false : true,
              mode: Mode.MENU,
              showSelectedItem: true,
              items: nacionalidadesMap.values.toList(),
              hint: "Seleccionar nacionalidad",
              onChanged: (data) {
                setState(() {
                  nacionalidadController.text = data.toString();
                });
              },
              selectedItem: visualizar == false
                  ? nacionalidadesMap[informacionInicial['idNacionalidad']]
                  : nacionalidadController.text,
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
              "Estatus",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87),
            ),
            SizedBox(height: 5),
            DropdownSearch<String>(
              enabled: visualizar == false ? false : true,
              selectedItem: visualizar == false
                  ? informacionInicial['estatus']
                  : estatusController.text,
              mode: Mode.MENU,
              showSelectedItem: true,
              items: estatusList,
              hint: "Seleccionar estatus",
              onChanged: (data) {
                setState(() {
                  estatusController.text = data.toString();
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
          readOnly: visualizar == false ? true : false,
          controller: nameController,
          obscureText: obscureText,
          validator: (item) {
            switch (label) {
              case "Nombres":
              case "Apellido Paterno":
              case "Apellido Materno":
              case "Empresa":
                return validarTamCampo(item, maxLength);
              case "Teléfono":
                return validarTelefono(item, maxLength);
              case "Correo electrónico":
                return validarCorreoElectronico(item, maxLength);
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

  void informacionResetear() {
    setState(() {
      nameController.text = informacionInicial['nombres'].toString();
      paternoController.text = informacionInicial['paterno'].toString();
      maternoController.text = informacionInicial['materno'].toString();
      emailController.text = informacionInicial['email'].toString();
      nacionalidadController.text =
          nacionalidadesMap[informacionInicial['idNacionalidad']].toString();
      estatusController.text = informacionInicial['estatus'].toString();
      empresaController.text = informacionInicial['empresa'].toString();
      telController.text = informacionInicial['tel'].toString();
    });
  }

  void _mostrarAlerta(
      BuildContext context, String question, String mensaje, String cambiar) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question),
        content: Text(mensaje),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                setState(() {
                  cambio = "Ninguno";
                });
                Navigator.of(context).pop(false);
              },
              child: Text("No")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                if (formKey.currentState!.validate()) {
                  setState(() {
                    cambio = cambiar;
                    _loadingFull = true;
                  });
                  if (cambio == "Dos" || cambio == "Estatus") {
                    revisarUsuario();
                  } else {
                    setInformacion();
                  }
                }
              },
              child: Text("Si")),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';

//DIRECTORIO
import 'package:hypeapp/various.dart';

class ProductsServicesSupplierPage extends StatefulWidget {
  _ProductsServicesSupplierState createState() =>
      _ProductsServicesSupplierState();
}

class _ProductsServicesSupplierState
    extends State<ProductsServicesSupplierPage> {
  var imagePath;
  //LOADING
  bool _loading = false;
  //VALIDACION
  final _formKey = new GlobalKey<FormState>();

  //SELECT   - - - - - - - - - - - -   Verificar consulta
  Map<String, String> nacionalidadesMap = {}, perfilesMap = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    limpiarControllers();
    super.dispose();
  }

  Future nacionalidades() async {
    var response = await http.post(
      Uri.parse("http://10.0.0.7/hypeapp/hypeapp_php/basic_controller.php"),
      body: {"tipo": "categorias"}, // confirmar nombre del campo categorias
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["resp"] == "Success") {
        setState(() {
          data["body"].forEach((key, value) {
            nacionalidadesMap[key] = value;
          });
        });
      } else if (data["resp"] == "fail") {
        messageSimple("No se ha podido obtener las categorias");
      }
    } else {
      messageSimple("No se ha podido realizar la conexion");
      Navigator.of(context).pop();
    }
  }

  //INSERT INTO

  Future registro() async {
    nacionalidadesMap.forEach((key, value) {
      if (value == nacionalidadController.text) {
        nacionalidadController.text = key;
      }
    });
    perfilesMap.forEach((key, value) {
      if (value == perfilController.text) {
        perfilController.text = key;
      }
    });
    var response = await http.post(
        Uri.parse("http://10.0.0.7/hypeapp/hypeapp_php/basic_controller.php"),
        body: {
          "tipo": "registro", // - - - - -  Modificar nombres
          "nombres": nameController.text,
          "ap_pat": paternoController.text,
          "ap_mat": maternoController.text,
          "email": emailController.text,
          "empresa": empresaController.text,
          "tel": telController.text,
          "password": passController.text,
          "nacionalidad": nacionalidadController.text,
          "perfil": perfilController.text
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      if (data["resp"] == "Success") {
        messageSimple("Se ha registrado correctamente");
        setState(() {
          _loading = false;
        });
        Navigator.of(context).pop();
      } else if (data["resp"] == "fail") {
        String message = "";
        switch (data["body"]) {
          case "492":
            message = "No se ha podido realizar el registro";
            break;
          default:
            message = "No se ha podido llevar a cabo la operacion";
            break;
        }
        messageSimple(message);
        setState(() {
          _loading = false;
        });
      }
    } else {
      messageSimple("No se ha podido realizar la conexion");
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
    }
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
                    "Agregar Producto",
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
                        label: "Nombres",
                        nameController: nameController,
                        maxLength: "80"),
                    inputFile(
                        label: "Categoria",
                        nameController:
                            paternoController, //Confirmar nombre del campo
                        maxLength: "40"),
                    inputFile(
                        label: "Precio",
                        nameController:
                            maternoController, //Confirmar nombre del campo
                        maxLength: "40"),
                    //Se agrega un TextField para poder
                    //tener la opcion multilinea
                    Text("Descripción:"),
                    TextField(
                      maxLength: 200,
                      keyboardType: TextInputType.multiline,
                      //Nombre de controlador pendiente
                    ),
                    Text("Agregar imagen:"),
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
                    /*
                    inputFile(
                        label: "Descripción",
                        nameController: emailController,
                        maxLength: "50",
                        ),
                        */
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
    return _loading == false ? buttonSignUp() : loadingSimple();
  }

  Widget buttonSignUp() {
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
              //registro
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  _loading = true;
                });
                registro();
              }
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
          items: nacionalidadesMap.values.toList(),
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

  Widget dropdownPerfil() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Perfil",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(height: 5),
        DropdownSearch<String>(
          enabled: _loading == false ? true : false,
          mode: Mode.MENU,
          showSelectedItem: true,
          items: perfilesMap.values.toList(),
          hint: "Seleccionar perfil",
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
              case "Nombres":
              case "Apellido Paterno":
              case "Apellido Materno":
              case "Empresa":
                return validarTamCampo(item, maxLength);
              case "Teléfono":
                return validarTelefono(item, maxLength);
              case "Correo electrónico":
                return validarCorreoElectronico(item, maxLength);
              case "Password":
                return validarPassword(item);
              case "Confirm Password":
                return validarConfirmPassword(item, passController);
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

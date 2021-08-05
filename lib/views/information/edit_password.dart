import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:hypeapp/views/constants.dart';

import 'package:hypeapp/views/various.dart';

class EditingPasswordPage extends StatefulWidget {
  const EditingPasswordPage({Key? key}) : super(key: key);

  @override
  _EditingPasswordState createState() => _EditingPasswordState();
}

class _EditingPasswordState extends State<EditingPasswordPage> {
  bool _loadingSimple = false;

  final formKey = new GlobalKey<FormState>();
  final box = GetStorage();

  TextEditingController newPassController = new TextEditingController();
  TextEditingController confirmNewPassController = new TextEditingController();

  Future setPassword() async {
    var response = await http.post(
      Uri.parse(SERVIDOR),
      body: {
        "tipo": "editar password",
        "email": box.read("email"),
        "pass_new": newPassController.text
      },
    );
    if (!mounted) return;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["resp"] == "success") {
        messageSimple("Se ha actualizado el password");
        limpiarCampos();
      } else if (data["resp"] == "fail") {
        messageSimple("No ha sido posible realizar la accion");
      }
      setState(() {
        _loadingSimple = false;
      });
    } else {
      messageSimple("No se ha podido realizar la conexion");
      setState(() {
        _loadingSimple = false;
      });
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
            Get.back();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Cambiar Contraseña",
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
                key: formKey,
                child: Column(
                  children: <Widget>[
                    inputFile(
                        label: "Nueva Contraseña",
                        obscureText: true,
                        nameController: newPassController),
                    inputFile(
                        label: "Confirmar Nueva Contraseña",
                        obscureText: true,
                        nameController: confirmNewPassController),
                  ],
                ),
              ),
              buttons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttons() {
    return _loadingSimple ? loadingSimple() : buttonsPassword();
  }

  Widget buttonsPassword() {
    return Column(
      children: [
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
                  //guardar password
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _loadingSimple = true;
                    });
                    setPassword();
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
                  limpiarCampos();
                },
                color: Color(0xffFF4638),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Limpiar",
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
      ],
    );
  }

  Widget inputFile({label, obscureText = false, nameController}) {
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
          readOnly: _loadingSimple ? true : false,
          controller: nameController,
          validator: (item) {
            switch (label) {
              case "Nueva Contraseña":
                return validarPassword(item);
              case "Confirmar Nueva Contraseña":
                return validarConfirmPassword(item, newPassController);
            }
          },
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

  void limpiarCampos() {
    FocusScope.of(context).unfocus();
    formKey.currentState!.reset();
    newPassController.clear();
    confirmNewPassController.clear();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:hypeapp/views/constants.dart';
import 'package:hypeapp/views/various.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //LOADING
  bool _loading = false;

  //VALIDATION
  final formKey = new GlobalKey<FormState>();

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    box.read("email") != null
        ? emailController.text = box.read("email")
        : emailController.text = "";
  }

  //
  @override
  void dispose() {
    limpiarControllers();
    super.dispose();
  }

  //LOGIN
  Future<void> login() async {
    var response = await http.post(Uri.parse(SERVIDOR), body: {
      "tipo": "ingresar",
      "email": emailController.text,
      "pass": passController.text,
    });
    if (!mounted) return;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      if (data["resp"] == "success") {
        messageLogin(emailController.text);
        box.write("email", emailController.text);
        setState(() {
          _loading = false;
        });

        limpiarControllers();
        switch (data["body"]) {
          case "Proveedor":
            Get.offNamed("/supplier");
            break;
          case "Organizador":
            Get.offNamed("/organizer");
            break;
        }
      } else if (data["resp"] == "fail") {
        String _message = "";
        switch (data["body"]) {
          case "401":
            _message = "Email o Contraseña incorrecta, revisar por favor";
            break;
          case "402":
            _message = "Perfil no encotrado, volver a intentar";
            break;
          default:
            _message = "No se ha podido realizar la operacion";
            break;
        }
        messageSimple(_message);
        setState(() {
          _loading = false;
        });
      }
    } else {
      messageSimple("No se ha podido realizar la conexion");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? WillPopScope(onWillPop: () async => false, child: LoadingFull())
        : Scaffold(
            resizeToAvoidBottomInset: false,
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
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "LogIn",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Ingresa con tu cuenta",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              inputFile(
                                  label: "Correo electrónico",
                                  obscureText: false,
                                  nameController: emailController,
                                  maxLength: "50"),
                              inputFile(
                                  label: "Contraseña",
                                  obscureText: true,
                                  nameController: passController),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Olvidaste tu contraseña? "),
                                  Text(
                                    " Presiona aquí!",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
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
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              //login
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                setState(() {
                                  _loading = true;
                                });
                                login();
                              }
                            },
                            color: Color(0xff08497F),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "Iniciar",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 100),
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/background.png"),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("¿Aún no tienes cuenta?"),
                          MaterialButton(
                            onPressed: () {
                              limpiarControllers();
                              Get.toNamed("/registro");
                            },
                            child: Text(
                              "Regístrate!",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ),
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
          obscureText: obscureText,
          controller: nameController,
          validator: (item) {
            switch (label) {
              case "Correo electrónico":
                return validarCorreoElectronico(item, maxLength);
              case "Contraseña":
                return validarPassword(item);
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

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hypeapp/models/model.dart';

//controllers
//Son los que se encargara de mandar la informacion que se escribe en los campos
TextEditingController emailController = new TextEditingController();
TextEditingController passController = new TextEditingController();
TextEditingController nameController = new TextEditingController();
TextEditingController paternoController = new TextEditingController();
TextEditingController maternoController = new TextEditingController();
TextEditingController empresaController = new TextEditingController();
TextEditingController telController = new TextEditingController();
TextEditingController nacionalidadController = new TextEditingController();
TextEditingController perfilController = new TextEditingController();
TextEditingController estatusController = new TextEditingController();
TextEditingController confirmController = new TextEditingController();
//eventos
TextEditingController eventoNombre = new TextEditingController();
TextEditingController eventoCategoria = new TextEditingController();
TextEditingController eventoHoraInicio = new TextEditingController();
TextEditingController eventoHoraFinal = new TextEditingController();
TextEditingController eventoFecha = new TextEditingController();
TextEditingController eventoLocacion = new TextEditingController();
TextEditingController eventoLocacionRespaldo = new TextEditingController();
TextEditingController eventoDescripcion = new TextEditingController();
TextEditingController eventoBanquetes = new TextEditingController();
TextEditingController eventoTipoBanquetes = new TextEditingController();
TextEditingController eventoProductoServicio = new TextEditingController();
TextEditingController eventoTipoProductoServicio = new TextEditingController();
TextEditingController eventoProductoOServicio = new TextEditingController();
TextEditingController eventoInformacionExtra = new TextEditingController();
//productos_servicios
TextEditingController productoNombre = new TextEditingController();
TextEditingController productoCategoria = new TextEditingController();
TextEditingController productoPrecio = new TextEditingController();
TextEditingController productoDescripcion = new TextEditingController();
TextEditingController productoImagen = new TextEditingController();

void limpiarControllers() {
  nameController.clear();
  paternoController.clear();
  maternoController.clear();
  emailController.clear();
  telController.clear();
  empresaController.clear();
  nacionalidadController.clear();
  perfilController.clear();
  passController.clear();
  estatusController.clear();
  confirmController.clear();
  //eventos
  eventoBanquetes.clear();
  eventoCategoria.clear();
  eventoDescripcion.clear();
  eventoFecha.clear();
  eventoHoraFinal.clear();
  eventoHoraInicio.clear();
  eventoInformacionExtra.clear();
  eventoLocacion.clear();
  eventoLocacionRespaldo.clear();
  eventoNombre.clear();
  eventoProductoOServicio.clear();
  eventoProductoServicio.clear();
  eventoTipoBanquetes.clear();
  eventoTipoProductoServicio.clear();
  //producto
  productoCategoria.clear();
  productoDescripcion.clear();
  productoImagen.clear();
  productoNombre.clear();
  productoPrecio.clear();
}

List<CatalogModel> catalogo = [];

//messages
void messageLogin(email) {
  Fluttertoast.showToast(
    msg: "Bienvenido " + email,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

void messageSimple(text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

//validations
String? validarDropDown(item) {
  if (item == null) {
    return "Selecciona una opci??n";
  }
  return null;
}

String? validarTamCampo(item, max) {
  if (item.length > int.parse(max)) {
    return "El maximo de caracteres es: " + max;
  } else if (item.length <= 0) {
    return "Rellenar el campo";
  }
  return null;
}

String? validarTelefono(item, max) {
  String pattern = (r"^[0-9]{10}$");
  RegExp regExp = new RegExp(pattern);
  if (item.length <= 0) {
    return "Ingresar un numero telefonico";
  } else if (item.length > int.parse(max)) {
    return "El maximo de caracteres es: " + max;
  } else if (!regExp.hasMatch(item)) {
    return "Numero telefonico incorrecto";
  }
  return null;
}

String? validarCorreoElectronico(item, max) {
  String pattern =
      (r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");
  RegExp regExp = new RegExp(pattern);
  if (item.length <= 0) {
    return "Ingresar un correo electr??nico";
  } else if (item.length > int.parse(max)) {
    return "El maximo de caracteres es: " + max;
  } else if (!regExp.hasMatch(item)) {
    return "Correo electr??nico invalido";
  }
  return null;
}

String? validarPassword(item) {
  String pattern =
      (r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])([A-Za-z\d$@$!%*?&]|[^ ]){8,15}$");
  RegExp regExp = new RegExp(pattern);
  if (item.length < 8 || item.length > 16) {
    return "Debe tener entre 8 y 16 caracteres";
  } else if (!regExp.hasMatch(item)) {
    return "Debe contener al menos un digito, una minuscula, una mayuscula y un simbolo";
  }
  return null;
}

String? validarConfirmPassword(item, controller) {
  if (item.length <= 0) {
    return "Rellenar campo";
  } else if (item != controller.text) {
    return "No es igual a la contrase??a";
  }
  return null;
}

//LOADINGS
class LoadingFull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xff08497F),
          size: 65.0,
        ),
      ),
    );
  }
}

Widget loadingSimple() {
  return Center(
    child: SpinKitChasingDots(
      color: Color(0xff08497F),
      size: 65.0,
    ),
  );
}

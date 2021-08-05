import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';

//DIRECTORIO
import '../organizer.dart';
import '../various.dart';

class EditarEventosOrganizerPage extends StatefulWidget {
  List list;
  int index;

  EditarEventosOrganizerPage({required this.list, required this.index});
  _EditarEventosOrganizerPage createState() => _EditarEventosOrganizerPage();
}

class _EditarEventosOrganizerPage extends State<EditarEventosOrganizerPage> {
  //controladores
  TextEditingController controlNombreEvento = new TextEditingController();

  var imagePath;
  //LOADING
  bool _loading = false;
  //VALIDACION
  final _formKey = new GlobalKey<FormState>();

  //SELECT   - - - - - - - - - - - -   Verificar consulta
  Map<String, String> tipoEventoMap = {
        "1": "Social",
        "2": "Empresarial",
        "3": "Otro",
      },
      perfilesMap = {};

  //editaDataFunction
  void editData() {
    var url = Uri.parse(
        "https://hypeapp1.herokuapp.com/eventsproducts_php/editevent.php");
    http.post(url, body: {
      "idEvento": widget.list[widget.index]['idEvento'],
      "nombre": eventoNombre.text,
      "Tipo_Evento": eventoCategoria.text,
      "descripcion": eventoDescripcion.text,
      "fecha": eventoFecha.text,
      "hor_inicial": eventoHoraInicio.text,
      "hor_final": eventoHoraFinal.text,
      "locacion": eventoLocacion.text,
      "locacion_resp": eventoLocacionRespaldo.text,
      "idBanquete": eventoTipoBanquetes.text,
      "idProducto_Servicio": eventoProductoServicio.text,
      "idTipo": eventoTipoProductoServicio.text,
      "idTipos": eventoProductoOServicio.text,
      "desc_extra": eventoInformacionExtra.text,
    });
  }

  @override
  void initState() {
    eventoNombre..text = widget.list[widget.index]['nombre'];
    eventoCategoria..text = widget.list[widget.index]['idTipo_Evento'];
    eventoFecha..text = widget.list[widget.index]['fecha'];
    eventoHoraInicio..text = widget.list[widget.index]['hor_inicial'];
    eventoHoraFinal..text = widget.list[widget.index]['hor_final'];
    eventoLocacion..text = widget.list[widget.index]['locacion'];
    eventoLocacionRespaldo..text = widget.list[widget.index]['locacion_resp'];
    eventoDescripcion..text = widget.list[widget.index]['descripcion'];
    eventoBanquetes..text = "3";
    eventoTipoBanquetes..text = "Banquetes dos soles";
    eventoProductoServicio..text = "producto1";
    eventoTipoProductoServicio..text = "1";
    eventoProductoOServicio..text = "producto";
    eventoInformacionExtra
      ..text =
          "Entrar al primer camino de terraceria para llegar a la locacion";
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
                    "Editar Evento",
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
              editData();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrganizerPage()));
            },
            color: Color(0xff08497F),
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
          items: tipoEventoMap.values.toList(),
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
              hintText: hint,
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

  Widget inputDate(
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
              hintText: label,
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

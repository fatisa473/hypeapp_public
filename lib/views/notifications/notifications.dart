import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hypeapp/models/provider.dart';
import 'package:hypeapp/views/constants.dart';

/*
Proveedor - Notificaciones
  Recordatorios de los eventos que tiene 
  De las peticiones de los eventos. //Es el unico que se guardara en la base de datos 

Organizador - Notificaciones
  Recordatorios de los eventos que tiene 
  Respuesta de las peticiones. 
*/

List<String> notificacionesMessage = [
  "Notificacion Sencilla",
  "Notificacion Sencilla 2",
  "Notificacion Sencilla 3",
  "Notificacion Sencilla 4",
  "Notificacion Sencilla 5",
  "Notificacion Sencilla 6"
];

List<bool> tipoNotificacion = [true, false, true, false, true, true];

PushNotificationService push = new PushNotificationService();

//Las notificaciones para el organizador, seran hacia sus eventos
//Las notificaciones para el proveedor, seran hacia los eventos que participara y le llegaran

//Seran una pagina de notificaciones diferente para cada perfil

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    push.pruebaEnvio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Text(
          ("Notificaciones"),
          style: TextStyle(
            fontSize: fontSize_AppBar,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor_AppBar,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          subEncabezado(),
          Flexible(
            child: _listMessage(),
          ),
        ],
      ),
    );
  }

  //
  Widget subEncabezado() {
    return Container(
      width: double.infinity,
      height: 56, //85,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 2,
                left: 10,
                right: 10,
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "Resultados",
                          style: TextStyle(
                            color: const Color(0xffc4c2bf),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //
}

Widget _listMessage() => ListView.builder(
      shrinkWrap: true,
      itemCount: notificacionesMessage.length,
      itemBuilder: (BuildContext context, int index) {
        return tipoNotificacion[index] == true
            ? Message(index)
            : Question(index);
      },
    );

Widget Message(index) {
  return Dismissible(
    key: ObjectKey(notificacionesMessage[index]),
    child: CardNotificacionMessage(notificacionesMessage[index]),
    onDismissed: (direction) {
      /*setState(() {
              notificacionesMessage.removeAt(index);
            });*/
    },
  );
}

Widget Question(index) {
  return Column(
    children: <Widget>[CardNotificacionQuestion(notificacionesMessage[index])],
  );
}

class CardNotificacionMessage extends StatelessWidget {
  final index;
  const CardNotificacionMessage(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
      ),
      margin: EdgeInsets.only(bottom: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  index.toString(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            width: 500.0,
            height: 100.0,
          ),
        ],
      ),
    );
  }
}

class CardNotificacionQuestion extends StatelessWidget {
  final index;
  const CardNotificacionQuestion(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: Column(
              children: [
                Text(
                  index.toString(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            width: 500.0,
            height: 60.0,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  height: 20,
                  onPressed: () {},
                  color: Color(0xffFF9400),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                ),
                MaterialButton(
                  height: 20,
                  onPressed: () {},
                  color: Color(0xffFF9400),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  child: Text(
                    "Aceptar",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

List<String> notificacionesMessage = ["Notificacion Sencilla"];
List<String> notificacionesQuestion = ["Notificacion Pregunta"];

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Pagina de notificaciones"),
    );
  }
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

class ListNotificacionesMessage extends StatefulWidget {
  const ListNotificacionesMessage({Key? key}) : super(key: key);

  @override
  _ListNotificacionesMessageState createState() =>
      _ListNotificacionesMessageState();
}

class _ListNotificacionesMessageState extends State<ListNotificacionesMessage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: notificacionesMessage.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: ObjectKey(notificacionesMessage[index]),
            child: CardNotificacionMessage(notificacionesMessage[index]),
            onDismissed: (direction) {
              setState(() {
                notificacionesMessage.removeAt(index);
              });
            },
          );
        });
  }
}

class ListNotificacionesQuestion extends StatefulWidget {
  const ListNotificacionesQuestion({Key? key}) : super(key: key);

  @override
  _ListNotificacionesQuestionState createState() =>
      _ListNotificacionesQuestionState();
}

class _ListNotificacionesQuestionState
    extends State<ListNotificacionesQuestion> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: notificacionesQuestion.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              CardNotificacionQuestion(notificacionesQuestion[index])
            ],
          );
        });
  }
}

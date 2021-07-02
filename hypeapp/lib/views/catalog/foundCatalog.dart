import 'package:flutter/material.dart';

class FoundCatalogoTile extends StatefulWidget {
  final int number;

  const FoundCatalogoTile(this.number);

  @override
  _FoundCatalogoTile createState() => _FoundCatalogoTile();
}

class _FoundCatalogoTile extends State<FoundCatalogoTile> {
  bool applied = false;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 4.0,
        top: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            // toggle state on tap
            onTap: () {
              setState(() => applied = !applied);

              if (applied) {
                print("seleccionado");
              } else {
                print("no seleccionado");
              }
            },
            child: Container(
              //Contenedor Producto o Servicio
              height: 350,
              width: 170,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff940D5A),
                ), //
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 15.0),
                    blurRadius: 20.0,
                  ),
                ],
              ),
              //Contenedor Imagen
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                    ),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        height: 100,
                        width: 167,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                          ), //
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //color: Colors.red,
                    height: 20.0,
                    child: ListTile(
                      title: Text("Titulo"),
                      subtitle: Text("Subtitulo"),
                    ),
                  ),
                ],
              ),
              /*child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, right: 10.0, left: 30.0, bottom: 3.0),
                    child: Text(
                      "${widget.number}",
                      style: TextStyle(
                          color: Color(0xff00315C),
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Instructor \nMahfuz A.",
                      style: TextStyle(
                        color: Color(0xff00315C),
                        fontSize: 12.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      // toggle state on tap
                      onPressed: () {
                        setState(() => applied = !applied);
                      },
                      // set color based on state
                      color: applied ? Colors.green : Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 65.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(17),
                              bottomLeft: Radius.circular(17))),
                      child: applied
                          ? Icon(Icons.access_alarm)
                          : Text(
                              "Apply",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  )
                ],
              ),*/
            ),
          ),
        ],
      ),
    );
  }
}

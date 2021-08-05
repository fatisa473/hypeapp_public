import 'package:flutter/material.dart';

import 'package:hypeapp/views/constants.dart';
import 'package:hypeapp/views/various.dart';

class FoundCatalogoTile extends StatefulWidget {
  final int number;

  const FoundCatalogoTile(this.number, {Key? key}) : super(key: key);

  @override
  _FoundCatalogoTile createState() => _FoundCatalogoTile();
}

class _FoundCatalogoTile extends State<FoundCatalogoTile> {
  String _proveedor = "Nombre del Proveedor";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(catalogo[widget.number].name),
          backgroundColor: bgColor_AppBar,
          actions: <Widget>[
            new IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Container(
          child: ListView(
            children: [
              SizedBox(height: 20.0),
              Container(
                height: 220.0,
                width: 400.0,
                child: Container(
                  child: Image.network(catalogo[widget.number].image),
                  height: MediaQuery.of(context).size.height / 3,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                //color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 22.0,
                          height: 22.0,
                          //color: Colors.red,
                          child: Icon(Icons.priority_high),
                        ),
                        Container(
                          //height: 220.0,
                          width: MediaQuery.of(context).size.height / 2.4,
                          //color: Colors.blue,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              catalogo[widget.number].description,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Container(
                          width: 22.0,
                          height: 22.0,
                          //color: Colors.red,
                          child: Icon(Icons.perm_identity),
                        ),
                        Container(
                          //height: 220.0,
                          width: 220.0,
                          //color: Colors.blue,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              catalogo[widget.number].proveedor,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Container(
                          width: 22.0,
                          height: 22.0,
                          //color: Colors.red,
                          child: Icon(Icons.price_check),
                        ),
                        Container(
                          //height: 220.0,
                          width: 220.0,
                          //color: Colors.blue,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              catalogo[widget.number].price.toString(),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import 'package:hypeapp/views/information/edit_information.dart';
import 'package:hypeapp/views/events_organizer/events_organizer.dart';
import 'package:hypeapp/views/notifications/notifications.dart';
import 'package:hypeapp/views/catalog/catalog.dart';
import 'package:hypeapp/constants.dart';

class OrganizerPage extends StatefulWidget {
  const OrganizerPage({Key? key}) : super(key: key);

  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<OrganizerPage> {
  int _selectedIndex = 1;

  // Barra de busqueda
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text(
    "Productos y Servicios",
    style: TextStyle(
      fontSize: fontSize_AppBar,
      fontWeight: FontWeight.bold,
    ),
  );
  //

  final _pages = [
    NotificationsPage(),
    ProductsServicesCatalogPage(),
    EventsOrganizerPage(),
    EditInfoPage(),
  ];

  List<Icon> normalIcon = [
    Icon(Icons.notifications_none),
    Icon(Icons.view_agenda),
    Icon(Icons.edit),
    Icon(Icons.info),
  ];

  List<String> bottomNavigationTitle = [
    "Notificaciones",
    "Catalogo",
    "Administrar",
    "Información",
  ];

  /*List<String> normalTitle = [
    "Notificaciones",
    "Productos y Servicios",
    "Agregar Productos y Servicios",
    "Editar Información",
  ];*/

  Text _appBarTitle(_title) {
    return new Text(
      _title,
      style: TextStyle(
        fontSize: fontSize_AppBar,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          appBarTitle = _appBarTitle("Notificaciones");
          break;
        case 1:
          appBarTitle = _appBarTitle("Productos y Servicios");

          break;
        case 2:
          appBarTitle = _appBarTitle("Tus Eventos");
          break;
        case 3:
          appBarTitle = _appBarTitle("Información");
          break;
      }
    });
  }

  AppBar buildAppBar() {
    if (_selectedIndex == 1) {
      return new AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: bgColor_AppBar,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            tooltip: "Buscar",
            iconSize: iconSize_AppBar, //24,
            onPressed: () {
              _searchBar();
            },
          ),
        ],
      );
    } else {
      return new AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: appBarTitle,
        backgroundColor: bgColor_AppBar,
      );
    }
  }

  BottomNavigationBar buildBottomNavigation() {
    //final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return new BottomNavigationBar(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: colorSelectedItem,
      unselectedItemColor: colorUnselectedItem.withOpacity(.60),
      selectedFontSize: fontSize_BNavigationTitle,
      unselectedFontSize: fontSize_BNavigationTitle,
      selectedLabelStyle: textTheme.caption,
      unselectedLabelStyle: textTheme.caption,
      mouseCursor: SystemMouseCursors.grab,
      iconSize: iconSize_BNavigationItem,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
          icon: normalIcon[0],
          label: bottomNavigationTitle[0],
        ),
        new BottomNavigationBarItem(
          icon: normalIcon[1],
          label: bottomNavigationTitle[1],
        ),
        new BottomNavigationBarItem(
          icon: normalIcon[2],
          label: bottomNavigationTitle[2],
        ),
        new BottomNavigationBarItem(
          icon: normalIcon[3],
          label: bottomNavigationTitle[3],
        ),
      ],
    );
  }

  //// Barra de busqueda ////
  void _searchBar() {
    setState(() {
      if (this.actionIcon.icon == Icons.search) {
        this.actionIcon = new Icon(Icons.close);
        this.appBarTitle = new Container(
          width: appBarTitle_AppBar,
          padding: EdgeInsets.all(18),
          child: Column(
            children: <Widget>[
              inputText(label: "Buscar Productos y Servicios"),
            ],
          ),
        );
      } else {
        this.actionIcon = new Icon(Icons.search);
        this.appBarTitle = _appBarTitle("Productos y Servicios");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: buildAppBar(),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: buildBottomNavigation(),
      ),
    );
  }

  Widget inputText({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 2,
        ),
        TextField(
          maxLines: 1,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            filled: true,
            fillColor: fillColorTextField_AppBar,
            hintText: label,
            hintStyle: TextStyle(
              fontSize: 13, //15
            ),
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderSideColor_AppBar,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderSideColor_AppBar,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //Boton de retroceso del celular - solo android
  Future<bool> _onBackPressed() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("¿Estas seguro de querer salir de la aplicacion?"),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No")),
          TextButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: Text("Si")),
        ],
      ),
    );
    return shouldPop ?? false;
  }
}

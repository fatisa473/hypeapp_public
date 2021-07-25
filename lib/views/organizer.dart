import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

import 'package:hypeapp/views/information/edit_information.dart';
import 'package:hypeapp/views/events_organizer/events_organizer.dart';
import 'package:hypeapp/views/notifications/notifications.dart';
import 'package:hypeapp/views/catalog/catalog.dart';
import 'package:hypeapp/views/constants.dart';

class OrganizerPage extends StatefulWidget {
  const OrganizerPage({Key? key}) : super(key: key);

  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<OrganizerPage> {
  int _selectedIndex = 1;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: buildBottomNavigation(),
      ),
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

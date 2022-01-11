import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sophia_hub/view/page/diary/create_diary_note_page.dart';
import 'package:sophia_hub/view/page/home/home.dart';
import 'package:sophia_hub/view/page/home/notes.dart';
import 'package:sophia_hub/view/page/home/quote.dart';
import 'package:sophia_hub/view/page/home/tasks.dart';

class Destination {
  const Destination(this.namedRoute, this.title, this.icon, this.color);

  final String namedRoute;
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('/', 'Trang chủ', Icons.home_filled, Colors.teal),
  Destination('/quotes', 'Quote', Icons.format_quote_outlined, Colors.cyan),
  Destination("/holder", "", null, null),
  Destination('/tasks', 'Nhiệm vụ', Icons.task_alt_outlined, Colors.orange),
  Destination('/notes', 'Nhật ký', Icons.event_note_sharp, Colors.blue),
];

class HomeContainer extends StatefulWidget {
  HomeContainer({Key key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  //Navigator with named route
  //https://stackoverflow.com/questions/49681415/flutter-persistent-navigation-bar-with-named-routes

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamed(CreateDiaryNotePage.nameRoute);
        },
      ),
      bottomNavigationBar: BottomAppBar(
//          clipBehavior: Clip.hardEdge,
//        shape: AutomaticNotchedShape(
//          BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
//          BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
//        ),
        child: BottomNavigationBar(

            currentIndex: _currentIndex,
            onTap: (i) {
              if (i == _currentIndex || i == 2) return;
              setState(() {
                _currentIndex = i;
              });

            },

            items: allDestinations.map((destination) {

              return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  backgroundColor: destination.color,
                  label: destination.title);
            }).toList()),
      ),
      body: Container(
          child: IndexedStack(
        index: _currentIndex,
        children: [
          HomeView(),
          QuoteView(),
          SizedBox(),
          TasksView(),
          NotesView()
        ],
      )),
    );
  }
}
// nếu dùng navigator
// setState(() {
//                switch (i) {
//                  case 0:
//                    if (_navigatorKey.currentState.canPop()) {
//                      _navigatorKey.currentState.pop();
//                      break;
//                    }
//                    _navigatorKey.currentState.pushNamed("/");
//                    break;
//                  case 1:
//                    if (_navigatorKey.currentState.canPop()) {
//                      _navigatorKey.currentState.pop();
//                      break;
//                    }
//                    _navigatorKey.currentState.pushNamed("/quotes");
//                    break;
//                  case 2:
//                    if (_navigatorKey.currentState.canPop()) {
//                      _navigatorKey.currentState.pop();
//                      break;
//                    }
//                    _navigatorKey.currentState.pushNamed("/tasks");
//                    break;
//                  case 3:
//                    if (_navigatorKey.currentState.canPop()) {
//                      _navigatorKey.currentState.pop();
//                      break;
//                    }
//                    _navigatorKey.currentState.pushNamed("/notes");
//                    break;
//                  default:
//                    throw Exception("No view for homeview index ${i}");
//                }
//                _currentIndex = i;
//              });
//
//
// Navigator(
//        key: _navigatorKey,
//        initialRoute: "/",
//        onGenerateRoute: (settings) {
//          WidgetBuilder builder;
//          // Manage your route names here
//          switch (settings.name) {
//            case '/':
//              builder = (BuildContext context) => HomeView();
//              break;
//            case '/quotes':
//              builder = (BuildContext context) => QuoteView();
//              break;
//            case '/tasks':
//              builder = (BuildContext context) => TasksView();
//              break;
//            case '/notes':
//              builder = (BuildContext context) => NotesView();
//              break;
//            default:
//              throw Exception('Invalid route: ${settings.name}');
//          }
//          // You can also return a PageRouteBuilder and
//          // define custom transitions between pages
//          return MaterialPageRoute(
//            builder: builder,
//            settings: settings,
//          );
//        },
//      )

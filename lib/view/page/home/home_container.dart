import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sophia_hub/constant/theme.dart';
import 'package:sophia_hub/view/page/note/create_note_page.dart';
import 'package:sophia_hub/view_model/note_view_model.dart';
import 'package:sophia_hub/view_model/quote_view_model.dart';
import 'package:sophia_hub/view_model/ui_logic.dart';

import 'notes/note_tab_view.dart';
import 'quote_tab/quote_tab.dart';

class Destination {
  const Destination(this.namedRoute, this.title, this.icon, this.color);

  final String namedRoute;
  final String? title;
  final IconData? icon;
  final MaterialColor? color;
}

const List<Destination> allDestinations = <Destination>[
  // Destination('/', 'Trang chủ', Icons.home_filled, Colors.blue),

  // Destination("/holder", "", null, null),
  // Destination('/tasks', 'Nhiệm vụ', Icons.task_alt_outlined, Colors.orange),
  Destination('/notes', 'Nhật ký', Icons.library_books_rounded, null),

  Destination('/quotes', 'Quote', Icons.format_quote_rounded, null),
];

class HomeContainer extends StatefulWidget {
  HomeContainer({Key? key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer>
    with TickerProviderStateMixin {
  //Navigator with named route
  //https://stackoverflow.com/questions/49681415/flutter-persistent-navigation-bar-with-named-routes

  late List<AnimationController> _faders;
  late List<Key> _destinationKeys;
  late int _currentIndex;

  late AnimationController _hideBottomBar;

  @override
  void initState() {
    _currentIndex = Provider.of<UILogic>(context, listen: false).homePageIndex;

    _faders = allDestinations
        .map<AnimationController>((e) => AnimationController(
            vsync: this, duration: Duration(milliseconds: 1500)))
        .toList();
    _faders[_currentIndex].value = 1.0;

    _destinationKeys =
        List<Key>.generate(allDestinations.length, (index) => GlobalKey())
            .toList();

    _hideBottomBar =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..value = 1;

    super.initState();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    _hideBottomBar.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    //Kiểm tra có phải màn hình note không
    if (Provider.of<UILogic>(context, listen: false).homePageIndex != 0) {
      _hideBottomBar.forward();
    }
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.idle:
            break;
          case ScrollDirection.forward:
            _hideBottomBar.forward();
            break;
          case ScrollDirection.reverse:
            _hideBottomBar.reverse();
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesViewModel>(create: (context) => NotesViewModel()),
        ChangeNotifierProvider<QuoteViewModel>(create: (_) => QuoteViewModel()),
      ],
      builder: (context,child){
        return NotificationListener(
          onNotification: _handleScrollNotification,
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: allDestinations[_currentIndex].color,
              child: Icon(Icons.add),
              onPressed: () async {
                dynamic isAdd =
                await Navigator.of(context, rootNavigator: true).push(


                  CreateNotePage.route(Provider.of<NotesViewModel>(context,listen: false)),
                );
                if (isAdd is bool && isAdd) {}
              },
            ),
            bottomNavigationBar: SizeTransition(
              sizeFactor: _hideBottomBar,
              axisAlignment: -1.0,
              child: BottomAppBar(
                elevation: 8,
                clipBehavior: Clip.hardEdge,
                shape: AutomaticNotchedShape(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  continuousRectangleBorder,
                ),
                child: BottomNavigationBar(
                    backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    // backgroundColor: allDestinations[_currentIndex].color,
                    currentIndex: _currentIndex,
                    onTap: (i) {
                      // Thay đổi logic i == ở đây để phù hợp với số lượng màn hình
                      // if (i == _currentIndex || i == 1) return;
                      Provider.of<UILogic>(context, listen: false).homePageIndex = i;
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
            ),
            body: _buildContent(),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    // if(_currentIndex == 0){
    //   return _setFadeTransition(0, allDestinations[0]);
    // } else if (_currentIndex == 1){
    //   return _setFadeTransition(1, allDestinations[1]);
    // };
    // return Container();
    return Container(
        child: IndexedStack(
      index: _currentIndex,
      children: allDestinations.asMap().entries.map((entry) {
        int index = entry.key;
        Destination des = entry.value;
        return _setFadeTransition(index, des);
      }).toList(),
    ));
  }

  Widget _setFadeTransition(int index, Destination des) {
    Widget destinedView = Text('Unknown Route ');
    if (des.namedRoute == allDestinations[0].namedRoute) {
      destinedView = const NoteTabView();
    } else if (des.namedRoute == allDestinations[1].namedRoute) {
      destinedView = QuoteView();
    }
    Widget view = FadeTransition(
        opacity: _faders[index].drive(CurveTween(curve: Curves.easeIn)),
        child: KeyedSubtree(
          key: _destinationKeys[index],
          child: destinedView,
        ));

    if (index == _currentIndex) {
      _faders[index].forward();
      return view;
    } else {
      _faders[index].reverse();
      if (_faders[index].isAnimating) {
        return IgnorePointer(
          child: view,
        );
      }
      return Offstage(
        child: view,
      );
    }
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

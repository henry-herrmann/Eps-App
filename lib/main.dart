import 'package:event_planner/network/Authenticator.dart';
import 'package:event_planner/pages/Login.dart';
import 'package:event_planner/pages/Home.dart';
import 'package:event_planner/pages/Splash.dart';
import 'package:event_planner/pages/Events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool login = await Authenticator().validateSession();

  runApp(MaterialApp(
      home: !login ? const Login() : const App(),
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale("de", "DE")
      ],
      home: MainPage(0)
    );
  }
}

class MainPage extends StatefulWidget {
  final int comingFrom;
  const MainPage(this.comingFrom, {Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final _inactiveColor = Colors.white;

  late int coming;

  @override
  void initState() {
    coming = widget.comingFrom;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(coming > 0){
        _pageController.jumpToPage(coming);
        coming = 0;
      }
    });

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _navigationBar(),
      body: buildPageView()
    );
  }

  Widget _navigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.indigo,
      elevation: 0.0,
      currentIndex: _currentIndex,
      onTap: (index) => setState((){
        _currentIndex = index;
        _pageController.jumpToPage(_currentIndex);
      }),
      selectedItemColor: Colors.blue,
      unselectedItemColor: _inactiveColor,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Events"
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings"

        )
      ]
    );
  }

  PageController _pageController = PageController();

  Widget buildPageView() {
    return PageView(
      controller: _pageController,
      children: <Widget> [
        Home(),
        Events(_pageController),
        Splash()
      ],
      onPageChanged: (page) {
        setState(() => _currentIndex = page);
      },
    );
  }

}

import 'package:flutter/material.dart';
import 'package:upstate/upstate.dart';

void main() {
  runApp(StateWidget(state: StateObject({'size': 100}), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool useUpstate = true;

  @override
  void didChangeDependencies() {
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    controller.addListener(() {
      if (useUpstate) {
        StateObject.of(context)['size'].value = 100 + 50 * controller.value;
      }
      setState(() {});
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upstate Performance Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/flutter.png',
                    width: 100 + controller.value * 50,
                    height: 100 + controller.value * 50,
                  ),
                  PulsingLogo()
                ],
              ),
            ),
            Text("Normal animation     Passing values with Upstate"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Use Upstate: '),
                Switch(value: useUpstate, onChanged: (val){useUpstate=!useUpstate;}),
              ],
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PulsingLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateBuilder(
      paths: [
        StatePath(['size'])
      ],
      builder: (context, state, child) {
        return Image.asset('assets/flutter.png',
            width: state['size'].value, height: state['size'].value);
      },
    );
  }
}

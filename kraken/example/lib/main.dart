import 'package:flutter/material.dart' hide Element;
import 'package:kraken/kraken.dart';
import 'package:kraken/dom.dart';
import 'dart:ffi';
// import 'package:kraken_websocket/kraken_websocket.dart';
// import 'package:kraken_devtools/kraken_devtools.dart';
import 'dart:ui';

void main() {
  Kraken.defineCustomElement<ElementCreator>('sample-element',  (int targetId, Pointer<NativeEventTarget>? nativeEventTarget, ElementManager elementManager) {
    return SampleElement(targetId, nativeEventTarget, elementManager);
  });
  // Kraken.experimentEnableUICommandDump();
  // KrakenWebsocket.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kraken Browser',
      // theme: ThemeData.dark(),
      home: MyBrowser(),
    );
  }
}

class UICommandKraken extends StatelessWidget {
  UICommandKraken();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Render Kraken with UI Command'),
      ),
      body: Kraken(
        bundleURL: 'assets/bundle.js',
      ),
    );
  }
}

class MyBrowser extends StatefulWidget {
  MyBrowser({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyBrowser> {

  OutlineInputBorder outlineBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    borderRadius: const BorderRadius.all(
      Radius.circular(20.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final TextEditingController textEditingController = TextEditingController();

    Kraken? _kraken;
    AppBar appBar = AppBar(
        backgroundColor: Colors.black87,
        titleSpacing: 10.0,
        title: Container(
          height: 40.0,
          child: TextField(
            controller: textEditingController,
            onSubmitted: (value) {
              textEditingController.text = value;
              _kraken?.loadURL(value);
            },
            decoration: InputDecoration(
              hintText: 'Enter a app url',
              hintStyle: TextStyle(color: Colors.black54, fontSize: 16.0),
              contentPadding: const EdgeInsets.all(10.0),
              filled: true,
              fillColor: Colors.grey,
              border: outlineBorder,
              focusedBorder: outlineBorder,
              enabledBorder: outlineBorder,
            ),
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      );

    final Size viewportSize = queryData.size;
    return Scaffold(
        appBar: appBar,
        floatingActionButton: ElevatedButton(
          child: Text('Dump UI Command'),
          onPressed: () {
            // List<UICommand>? commands = _kraken?.experimentDumpUICommand();
            // if (commands != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UICommandKraken()));
            // }
          },
        ),
        body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _kraken = Kraken(
          viewportWidth: viewportSize.width - queryData.padding.horizontal,
          viewportHeight: viewportSize.height - appBar.preferredSize.height - queryData.padding.vertical,
          bundleURL: 'assets/bundle.js',
        ),
    ));
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      await SentryFlutter.init(
        (options) {
          options.dsn =
              'https://2a280ca981a249a1836a1972d0108a26@o1146690.ingest.sentry.io/6215724';
          options.tracesSampleRate = 1.0;
        },
        appRunner: () => runApp(const MyApp()),
      );
    },
    (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    },
  );
}

// Future<void> main() async {
//   await SentryFlutter.init(
//     (options) {
//       options.dsn =
//           'https://2a280ca981a249a1836a1972d0108a26@o1146690.ingest.sentry.io/6215724';
//       // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
//       // We recommend adjusting this value in production.
//       options.tracesSampleRate = 1.0;
//     },
//     appRunner: () => runApp(MyApp()),
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });

    try {
      print('Method might Fail');
      throw Exception("ERROR TO TEST NON OBFUSCATE");
    } catch (exception, stackTrace) {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

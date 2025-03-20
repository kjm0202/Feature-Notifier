import 'package:feature_notifier/feature_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  await FeatureNotifier.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature Notifier Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Feature Notifier test"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   debugPrint("Build Completed");
    //   FeatureBottomModalSheetNotifier.notify(
    //     context,
    //     title: "Modal sheet example",
    //     description: "Modal sheet is a good way to display a feature",
    //     onClose: () {
    //       debugPrint("The modal sheet was closed");
    //     },
    //     featureKey: 3,
    //     hasButton: true,
    //   );
    // });
  }

  void _reset() {
    setState(() {
      FeatureNotifier.persistAll();
    });
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
            Padding(
                padding: const EdgeInsets.all(20),
                child: FeatureCardNotifier(
                  title: "Testing this out",
                  hasButton: true,
                  description:
                      'You can now show items without inviting friends!',
                  featureKey: 'show_items_without_inviting_friends',
                  onClose: () {},
                  onTapCard: () {},
                  showIcon: true,
                  onTapButton: () {},
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: FeatureBarNotifier(
                title:
                    "Testing this out You have pushed the button this many times:",

                featureKey: 'how_mant_times_button_pushed',
                onClose: () {},
                onTapCard: () {},
                showIcon: true,
                // icon: Text("dog"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FeatureBottomModalSheetNotifier.notify(
                  context,
                  title: "Modal sheet example",
                  description: "Modal sheet is a good way to display a feature",
                  onClose: () {
                    debugPrint("The modal sheet was closed");
                  },
                  featureKey: 'test_modal_sheet',
                  hasButton: true,
                );
              },
              child: const Text("Show modal sheet"),
            ),
            ElevatedButton(
              onPressed: () {
                FeatureAlertNotifier.notify(
                  context,
                  title: "Alert example",
                  description: "Alert is a good way to display a feature",
                  onClose: () {
                    debugPrint("The alert was closed");
                  },
                  featureKey: 'test_alert',
                  hasButton: true,
                );
              },
              child: const Text("Show alert"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _reset();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reset completed"),
            ),
          );
        },
        label: const Text('Persist all features'),
        icon: const Icon(Icons.clear),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

[![Android](https://github.com/share-tracker/share-tracker/actions/workflows/android.yml/badge.svg?branch=dev&event=push)](https://github.com/share-tracker/share-tracker/actions/workflows/android.yml)
[![iOS](https://github.com/share-tracker/share-tracker/actions/workflows/iOS.yml/badge.svg?branch=dev&event=push)](https://github.com/share-tracker/share-tracker/actions/workflows/iOS.yml)

## Overview

The Share Tracker package allows you to track device movements, locations, and other related data in a foreground service within your Flutter application. This example demonstrates how to integrate and use the Share Tracker package to display location and movement data in a simple Flutter application.

## Requirements

- Flutter: Ensure you have Flutter installed and set up on your development environment.
- Package Dependency: The Share Tracker package must be added to your pubspec.yaml.

```yaml
dependencies:
  flutter:
    sdk: flutter
  share_tracker: ^1.0.0 # Replace with the latest version of the package
```

- iOS: Include the NSMotionUsageDescription key in your Info.plist file to grant the app permission to access motion data.

## Steps to Use

1. Initialize the Tracker Service:

```dart
void main() {
  TrackerService.instance.init();
  runApp(const ExampleApp());
}
```

2. Create the Main Application Widget:

```dart
class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}
```

3. Create the Main Page Widget:

```dart
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = TrackerController();

  @override
  void initState() {
    super.initState();
    _controller.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Location Service'),
      centerTitle: true,
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: _controller.listenable,
          builder: (BuildContext context, Tracker? location, _) {
            return _buildResultTable(location);
          },
        ),
      ),
    );
  }

  Widget _buildResultTable(Tracker? tracker) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('key')),
            DataColumn(label: Text('value')),
          ],
          rows: [
            DataRow(cells: _buildDataCells('timeStamp', tracker?.position?.timestamp)),
            DataRow(cells: _buildDataCells('stepCount', tracker?.stepCount?.steps)),
            DataRow(cells: _buildDataCells('status', tracker?.status)),
            DataRow(cells: _buildDataCells('latitude', tracker?.position?.latitude)),
            DataRow(cells: _buildDataCells('longitude', tracker?.position?.longitude)),
            DataRow(cells: _buildDataCells('altitude', tracker?.position?.altitude)),
            DataRow(cells: _buildDataCells('speed', tracker?.position?.speed != null ? (tracker.position!.speed * 3.6) : 0)),
            DataRow(cells: _buildDataCells('sendTime', tracker?.sendTime)),
          ],
        )
      ],
    );
  }

  List<DataCell> _buildDataCells(String key, dynamic value) {
    return [
      DataCell(Text(key)),
      DataCell(Text(value.toString())),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

4. Add a Message Listener to Update Location Data:

```dart
class TrackerController {
  final listenable = ValueNotifier<Tracker?>(null);

  void attach(State state) {
    TrackerService.instance.addTrackerListener((Tracker? tracker) {
      listenable.value = tracker;
    });
  }

  void dispose() {
    TrackerService.instance.removeTrackerListener();
  }
}
```

## How It Works

- TrackerService.instance.init(): Initializes the tracker service.
- TrackerService.instance.addTrackerListener(): Adds a listener to the tracker service that updates the ValueNotifier whenever new location or movement data is received.
- ValueListenableBuilder: Watches the ValueNotifier for changes and updates the UI accordingly.
- DataTable: Displays the received data (timestamp, step count, latitude, longitude, altitude, speed, sendTime) in a table format for easy visualization.

## Additional Information

For more detailed information on the Share Tracker package and its API, visit the package's documentation on pub.dev.

By following this example, you can effectively integrate and visualize location and movement data in your Flutter applications using the Share Tracker package.

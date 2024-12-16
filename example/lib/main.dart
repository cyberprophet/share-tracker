import 'package:flutter/material.dart';
import 'package:share_tracker/share_tracker.dart';

void main() {
  TrackerService.instance.init();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            DataRow(
                cells:
                    _buildDataCells('timeStamp', tracker?.position?.timestamp)),
            DataRow(
                cells: _buildDataCells('stepCount', tracker?.stepCount?.steps)),
            DataRow(cells: _buildDataCells('status', tracker?.status)),
            DataRow(
                cells:
                    _buildDataCells('latitude', tracker?.position?.latitude)),
            DataRow(
                cells:
                    _buildDataCells('longitude', tracker?.position?.longitude)),
            DataRow(
                cells:
                    _buildDataCells('altitude', tracker?.position?.altitude)),
            DataRow(
              cells: _buildDataCells(
                'speed',
                tracker?.position?.speed != null
                    ? (tracker!.position!.speed * 3.6)
                    : 0,
              ),
            ),
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

  final _controller = TrackerController(id: 101, title: 'tracker');
}

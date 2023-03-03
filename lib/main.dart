import 'package:air_quality/data/common/extensions.dart';
import 'package:air_quality/data/model/api/thingspeak.dart';
import 'package:air_quality/data/services/api/index.dart';
import 'package:air_quality/ui/chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<ThingSpeakData?> thingSpeakData;
  late ValueNotifier<List<ThingSpeakData>> dataList;

  @override
  void initState() {
    thingSpeakData = ThingSpeakServiceImpl().getStream().asBroadcastStream();
    dataList = ValueNotifier([]);
    thingSpeakData.listen((event) {
      if (event != null) {
        if (dataList.value.isNotEmpty &&
            dataList.value.last.createdAt == event.createdAt &&
            dataList.value.last.entryId == event.entryId) {
          return;
        }
        if (dataList.value.length >= 10) {
          dataList.value.removeAt(0);
        }
        dataList.value.add(event);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        StreamBuilder<ThingSpeakData?>(
          stream: thingSpeakData,
          builder: (context, snapshot) {
            return AppBar(
              backgroundColor: (snapshot.data?.entryId??1000)<700?
              Colors.green: Colors.red,
              title: const Text('Air Quality Detector'),
            );
          }
        ),
        Expanded(
          child: Center(
              child: StreamBuilder<ThingSpeakData?>(
            stream: thingSpeakData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.error_outline, color: Colors.orange),
                      SizedBox(width: 10),
                      Text('No connection'),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 18),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last Entry: ${snapshot.data?.createdAt.timeAgo()??''}',
                              style: const TextStyle(
                                fontSize: 17
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Value: ${snapshot.data?.entryId??'~'} PPM',
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Chart(dataList: dataList)),
                      Visibility(
                        visible: !snapshot.hasData || snapshot.data == null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.error_outline, color: Colors.red),
                                SizedBox(width: 10),
                                Text('Failed to get data from Sensor'),
                              ],
                            ),
                          )),
                    ],
                  ),
                );
              }
            },
          )),
        ),]
      ),
    );
  }
}

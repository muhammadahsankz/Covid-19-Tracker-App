import 'dart:convert';
import 'package:covid19_tracking/Models/covid_data_model.dart';
import 'package:covid19_tracking/Screens/regions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  final colorList = <Color>[
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Covid 19 Tracker App'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FutureBuilder(
                future: getCovidApi(),
                builder: (context, AsyncSnapshot<CovidDataModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.black,
                          size: 50,
                          controller: _controller,
                        ));
                  } else {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent.shade100.withOpacity(.7),
                              borderRadius: BorderRadius.circular(10)),
                          child: PieChart(
                            chartRadius: 100,
                            legendOptions: LegendOptions(
                              legendPosition: LegendPosition.left,
                            ),
                            dataMap: {
                              'Total': snapshot.data!.data!.summary!.total!
                                  .toDouble(),
                              'Recovered': snapshot
                                  .data!.data!.summary!.discharged!
                                  .toDouble(),
                              'Deaths': snapshot.data!.data!.summary!.deaths!
                                  .toDouble(),
                            },
                            chartValuesOptions: ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            animationDuration: Duration(seconds: 1),
                            chartType: ChartType.ring,
                            colorList: colorList,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                CovidDataRow(
                                  title: 'Total Cases',
                                  value: snapshot.data!.data!.summary!.total!
                                      .toString(),
                                ),
                                CovidDataRow(
                                  title: 'Confirmed Cases in India',
                                  value: snapshot.data!.data!.summary!
                                      .confirmedCasesIndian!
                                      .toString(),
                                ),
                                CovidDataRow(
                                  title: 'Confirmed Foreign Cases',
                                  value: snapshot.data!.data!.summary!
                                      .confirmedCasesForeign!
                                      .toString(),
                                ),
                                CovidDataRow(
                                  title: 'Total Recovered',
                                  value: snapshot
                                      .data!.data!.summary!.discharged!
                                      .toString(),
                                ),
                                CovidDataRow(
                                  title: 'Total Deaths',
                                  value: snapshot.data!.data!.summary!.deaths!
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegionsScreen()));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                              'Track Regions',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ]),
        ),
      ),
    );
  }
}

class CovidDataRow extends StatelessWidget {
  final title;
  final value;
  const CovidDataRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(value),
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

Future<CovidDataModel> getCovidApi() async {
  var response = await http
      .get(Uri.parse('https://api.rootnet.in/covid19-in/stats/latest'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body.toString());
    return CovidDataModel.fromJson(data);
  } else {
    throw Exception('Error');
  }
}

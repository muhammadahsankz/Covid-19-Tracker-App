import 'package:covid19_tracking/Screens/homepage.dart';
import 'package:flutter/material.dart';

class RegionsDetailsScreen extends StatefulWidget {
  final String region;
  final int confirmedCasesIndian;
  final int confirmedCasesForeign;
  final int discharged;
  final int deaths;
  final int totalConfirmed;

  const RegionsDetailsScreen({
    super.key,
    required this.region,
    required this.confirmedCasesForeign,
    required this.confirmedCasesIndian,
    required this.deaths,
    required this.discharged,
    required this.totalConfirmed,
  });

  @override
  State<RegionsDetailsScreen> createState() => _RegionsDetailsScreenState();
}

class _RegionsDetailsScreenState extends State<RegionsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.region),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.coronavirus,
            color: Colors.blue,
            size: 150,
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.pinkAccent.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CovidDataRow(
                      title: 'Total Cases',
                      value: widget.totalConfirmed.toString(),
                    ),
                    CovidDataRow(
                      title: 'Confirmed Cases in India',
                      value: widget.confirmedCasesIndian.toString(),
                    ),
                    CovidDataRow(
                      title: 'Confirmed Foreign Cases',
                      value: widget.confirmedCasesForeign.toString(),
                    ),
                    CovidDataRow(
                      title: 'Total Recovered',
                      value: widget.discharged.toString(),
                    ),
                    CovidDataRow(
                      title: 'Total Deaths',
                      value: widget.deaths.toString(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:covid19_tracking/Models/covid_data_model.dart';
import 'package:covid19_tracking/Screens/regions_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class RegionsScreen extends StatefulWidget {
  const RegionsScreen({super.key});

  @override
  State<RegionsScreen> createState() => _RegionsScreenState();
}

class _RegionsScreenState extends State<RegionsScreen> {
  final TextEditingController regionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Regions'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              onChanged: (value) {
                setState(() {});
              },
              controller: regionController,
              decoration: InputDecoration(
                  prefixIconColor: Colors.green,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search by Regions',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: FutureBuilder(
              future: getCovidApi(),
              builder: (context, AsyncSnapshot<CovidDataModel> snapshot) {
                if (!snapshot.hasData) {
                  return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                title: Container(
                                  height: 10,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                subtitle: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            baseColor: Colors.grey.shade700,
                            highlightColor: Colors.grey.shade100);
                      });
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.data!.regional!.length,
                      itemBuilder: (context, index) {
                        String name = snapshot.data!.data!.regional![index].loc
                            .toString();
                        if (regionController.text.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegionsDetailsScreen(
                                            region: snapshot.data!.data!
                                                .regional![index].loc
                                                .toString(),
                                            confirmedCasesForeign: int.parse(
                                                snapshot
                                                    .data!
                                                    .data!
                                                    .regional![index]
                                                    .confirmedCasesForeign
                                                    .toString()),
                                            confirmedCasesIndian: int.parse(snapshot
                                                .data!
                                                .data!
                                                .regional![index]
                                                .confirmedCasesIndian
                                                .toString()),
                                            deaths: int.parse(
                                                snapshot.data!.data!.regional![index].deaths.toString()),
                                            discharged: int.parse(snapshot.data!.data!.regional![index].discharged.toString()),
                                            totalConfirmed: int.parse(snapshot.data!.data!.regional![index].totalConfirmed.toString()))));
                              },
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                tileColor: Colors.pinkAccent.shade100,
                                leading: Icon(
                                  Icons.coronavirus,
                                  color: Colors.blue,
                                  size: 35,
                                ),
                                title: Text(
                                  snapshot.data!.data!.regional![index].loc
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(snapshot.data!.data!
                                        .regional![index].totalConfirmed
                                        .toString() +
                                    ' Cases'),
                              ),
                            ),
                          );
                        } else if (name
                            .toLowerCase()
                            .contains(regionController.text.toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegionsDetailsScreen(
                                            region: snapshot.data!.data!
                                                .regional![index].loc
                                                .toString(),
                                            confirmedCasesForeign: int.parse(
                                                snapshot
                                                    .data!
                                                    .data!
                                                    .regional![index]
                                                    .confirmedCasesForeign
                                                    .toString()),
                                            confirmedCasesIndian: int.parse(snapshot
                                                .data!
                                                .data!
                                                .regional![index]
                                                .confirmedCasesIndian
                                                .toString()),
                                            deaths: int.parse(
                                                snapshot.data!.data!.regional![index].deaths.toString()),
                                            discharged: int.parse(snapshot.data!.data!.regional![index].discharged.toString()),
                                            totalConfirmed: int.parse(snapshot.data!.data!.regional![index].totalConfirmed.toString()))));
                              },
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                tileColor: Colors.pinkAccent.shade100,
                                leading: Icon(
                                  Icons.coronavirus,
                                  color: Colors.blue,
                                  size: 35,
                                ),
                                title: Text(
                                  snapshot.data!.data!.regional![index].loc
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(snapshot.data!.data!
                                        .regional![index].totalConfirmed
                                        .toString() +
                                    ' Cases'),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      });
                }
              }),
        ),
      ]),
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

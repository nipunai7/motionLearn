import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ReportPage extends StatefulWidget {
  final String url;

  const ReportPage({Key key, this.url}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<_SalesData> data = [
    _SalesData('Attempt 1', 93),
    _SalesData('Attempt 2', 95),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 30.0,
          title: Text("Shuffle Dance Attempt 1"),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text("Tutorial Date: 2021.07.25",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                Text("Overall Performance: 95%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Center(
                      heightFactor: 1.1,
                      child: SfSparkBarChart(
                        color: Colors.deepPurple,

                        data: <double>[
                          95,
                          93,
                          96,
                          95,
                          96,
                          96,
                          95,
                          94,
                          95,
                          93,
                          97,
                          95
                        ],
                      )),
                ),
                Text("Bars from left to right",style: TextStyle(fontSize: 14.0),),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,bottom: 8.0,top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width:180.0,
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("1.Right Shoulder: 95%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("2.Right Elbow: 93%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("3.Right Wrist: 96%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("4.Right Hip: 95%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("5.Right Knee: 96%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("6.Right Ankle: 96%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                          ],
                        ),
                      ),
                      Container(
                        width: 174.0,
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("7.Left Shoulder: 95%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("8.Left Elbow: 94%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("9.Left Wrist: 95%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("10.Left Hip: 93%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("11.Left Knee: 97%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("12.Left Ankle: 95%",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        launch(widget.url);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        primary: Colors.deepPurple,
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 44.0,
                          child: Center(
                              child: Text(
                            "Download PDF",
                            style: TextStyle(fontSize: 18.0),
                          ))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //launch(widget.url);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        primary: Colors.deepPurple,
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 44.0,
                          child: Center(
                              child: Text(
                            "Overall report",
                            style: TextStyle(fontSize: 18.0),
                          ))),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),
                Container(
                  // height: 30.0,
                  child: Column(children: [
                    //Initialize the chart widget
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        title: ChartTitle(text: 'Your Overall Performance'),
                        // Enable legend
                        legend: Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<_SalesData, String>>[
                          LineSeries<_SalesData, String>(
                              dataSource: data,
                              xValueMapper: (_SalesData sales, _) => sales.year,
                              yValueMapper: (_SalesData sales, _) => sales.sales,
                              name: '',
                              // Enable data label
                              dataLabelSettings: DataLabelSettings(isVisible: true))
                        ]),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

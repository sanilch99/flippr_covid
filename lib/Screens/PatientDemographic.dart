import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flippr_covid/models/PatientData.dart';
import 'package:flippr_covid/utils/api.dart';
import 'package:flippr_covid/utils/colors.dart';
import 'package:flippr_covid/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:ui' as ui;

class PatientDemographic extends StatefulWidget {
  @override
  _PatientDemographicState createState() => _PatientDemographicState();
}

class _PatientDemographicState extends State<PatientDemographic> {

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  String ddVal="All";
  String ddValTwo="All";
  String ddValThree="All";
  RegExp state=RegExp("[a-zA-Z]");
  Gender g;
  int ageSelected=0;
  int selected=0;
  int start=0;
  int end=100;
  int dateSelected=0;
  DateTime startDate;
  DateTime endDate;
  int error=0;
  String startDay="Start Date";
  String endDay="End Date";

  @override
  void initState() {
    super.initState();
  }

  void _printScreen() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await wrapWidget(
        doc.document,
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));
      return doc.save();
    });
  }

  void _shareDoc() {
    Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
      final doc = pw.Document();

      final image = await wrapWidget(
        doc.document,
        key: _printKey,
        pixelRatio: 2.0,
      );

      doc.addPage(pw.Page(
          pageFormat: format,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Expanded(
                child: pw.Image(image),
              ),
            );
          }));

      await Printing.sharePdf(bytes: doc.save(), filename: 'my-document.pdf');
      return doc.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Graphical Analysis",
          style: TextStyle(
              color: secondaryColor,fontStyle: FontStyle.italic
          ),
        ),
        backgroundColor: primaryColor,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: secondaryColor,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [

          IconButton(
            icon: Icon(Icons.file_download,color: secondaryColor,),
            onPressed: (){
              _printScreen();
            },
          ),
          IconButton(
            icon: Icon(Icons.share,color: secondaryColor,),
            onPressed: (){
              _shareDoc();
            },
          ),
          IconButton(
            icon: Icon(Icons.sort,color: secondaryColor,),
            onPressed: (){
              _showDialog(context);
            },
          )

        ],
      ),
      backgroundColor: secondaryColor,
      body: Container(
        child:FutureBuilder<PatientData>(
          future: loadPatient(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RepaintBoundary(
                  key: _printKey,
                  child: SfCartesianChart(
                      borderColor: secondaryColor,
                      backgroundColor: primaryColor,
                      palette: [secondaryColor],
                      primaryXAxis: CategoryAxis(
                              title: AxisTitle(
                                  text: 'Date Reported On',
                                  textStyle: ChartTextStyle(
                                      color: secondaryColor,
                                      fontFamily: 'Roboto',
                                      fontSize: 8,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300
                                  )
                              )
                      ),
                      primaryYAxis: CategoryAxis(
                          title: AxisTitle(
                              text: 'Age Estimate',
                              textStyle: ChartTextStyle(
                                  color: secondaryColor,
                                  fontFamily: 'Roboto',
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300
                              ),
                          )
                      ),
                      // Chart title
                      title: ChartTitle(text: 'Age Estimate vs Date Reported',textStyle: TextStyle(fontWeight: FontWeight.bold,color: secondaryColor,fontStyle: FontStyle.italic)),
                      // Enable legend
                      legend: Legend(isVisible: false,title:LegendTitle(text: "Age Estimate")),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true,),
                      series: <ChartSeries<Datum, String>>[
                        LineSeries<Datum, String>(
                            dataSource: (selected==0)?
                            snapshot.data.data.where((element) => state.hasMatch(element.state)).toList().where((element) => element.ageEstimate>=start && element.ageEstimate<=end).toList(): // Deserialized Json data list.
                  dateSelected==0?snapshot.data.data.where((element) => state.hasMatch(element.state)).toList().where((element) => element.ageEstimate>=start && element.ageEstimate<=end).toList().where((element) => element.gender==g).toList():
                  snapshot.data.data.where((element) => state.hasMatch(element.state)).toList().where((element) => element.ageEstimate>=start && element.ageEstimate<=end).toList().where((element) => element.gender==g).toList().where((element) => convertString(element.reportedOn).isAfter(startDate) && convertString(element.reportedOn).isBefore(endDate)).toList(),
                            xValueMapper: (Datum pd, _) => pd.reportedOn.toString(),
                            yValueMapper: (Datum pd, _) => pd.ageEstimate,
                            // Enable data label
                            color: secondaryColor,
                            dataLabelSettings: DataLabelSettings(isVisible: true,useSeriesColor: true))
                      ]
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new CircularProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(secondaryColor)
            );
          },
        ),
      ),
    );
  }


  Future _showDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          backgroundColor: secondaryColor,
          contentPadding: EdgeInsets.all(4),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setMeta) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //your code dropdown button here
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Choose Your Filters",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20
                                ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        color: primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "State",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new DropdownButton<String>(
                                value: ddVal,
                                dropdownColor: primaryColor,
                                items: <String>["All","Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","Goa","Gujarat",
                                  "Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madhya Pradesh",
                                  "Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Odisha","Punjab","Rajasthan",
                                  "Sikkim","Tamil Nadu","Telangana","Tripura","Uttar Pradesh","Uttarakhand","West Bengal","Andaman and Nicobar","Chandigarh",
                                  "Dadra and Nagar Haveli","Daman and Diu","Lakshadweep","Delhi","Puducherry"].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,style: TextStyle(color: secondaryColor),),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setMeta(() {
                                    ddVal=value;
                                  });
                                  setState(() {
                                    if(value!="All") {
                                      state = RegExp(value);
                                    }else{
                                      state=RegExp("[a-zA-Z]");
                                    }
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Age Filter",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new DropdownButton<String>(
                                dropdownColor: primaryColor,
                                value: ddValTwo,
                                items: <String>['All','0-9', '10-19', '20-29', '30-39','40-49','50-59','60-69','70 and above'].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,style: TextStyle(color: secondaryColor),),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    ddValTwo=val;
                                    print(ddValTwo);
                                    if(ddValTwo=="All"){
                                      ageSelected=0;
                                      start=0;
                                      end=100;
                                    }else{
                                      ageSelected=1;
                                      print(ddValTwo);
                                      switch(val){
                                        case 'All':{
                                          start=0;
                                          end=100;
                                          break;
                                        }
                                        case '0-9':{
                                          start=0;
                                          end=9;
                                          break;
                                        }
                                        case '10-19':{
                                          start=10;
                                          end=19;
                                          break;
                                        }
                                        case '20-29':{
                                          start=20;
                                          end=29;
                                          break;
                                        }
                                        case '30-39':{
                                          start=30;
                                          end=39;
                                          break;
                                        }
                                        case '40-49':{
                                          start=40;
                                          end=49;
                                          break;
                                        }
                                        case '50-59':{
                                          start=50;
                                          end=59;
                                          break;
                                        }
                                        case '60-69':{
                                          start=60;
                                          end=69;
                                          break;
                                        }
                                        case '70 and above':{
                                          start=70;
                                          end=100;
                                          break;
                                        }
                                      }
                                    }
                                  });
                                  setMeta((){
                                    ddValTwo=val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Gender",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new DropdownButton<String>(
                                dropdownColor: primaryColor,
                                value: ddValThree,
                                items: <String>['All','male','female','N/A'].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,style: TextStyle(color: secondaryColor),),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    ddValThree=val;
                                    print(ddValThree);
                                    if(ddValThree=="All"){
                                      selected=0;
                                    }else{
                                      selected=1;
                                      switch(val){
                                        case 'male':{
                                          g=Gender.MALE;
                                          break;
                                        }
                                        case 'female':{
                                          g=Gender.FEMALE;
                                          break;
                                        }
                                        case 'N/A':{
                                          g=Gender.EMPTY;
                                          break;
                                        }
                                      }
                                    }
                                  });
                                  setMeta((){
                                    ddValThree=val;
                                  });
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.clear,color: secondaryColor,size: 10,),
                                  onPressed: (){
                                    setMeta((){
                                      startDay="Start Date";
                                      endDay="End Date";
                                    });
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        startDay,
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: 20
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.calendar_today,color: secondaryColor,),
                                        onPressed: (){
                                          showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.utc(2020,2,1), lastDate: DateTime.now()).then((value){
                                            setMeta(() {
                                              startDay=convertDate(value);
                                            });
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        endDay,
                                        style: TextStyle(
                                            color: secondaryColor,
                                            fontSize: 20
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.calendar_today,color: secondaryColor,),
                                        onPressed: (){
                                          showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.utc(2020,2,1), lastDate: DateTime.now()).then((value){
                                            setMeta(() {
                                              endDay=convertDate(value);
                                            });
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: error==1,
                              child: Row(
                                children: [
                                  Text("Start Date must be lesser than End Date*",
                                    style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          color: primaryColor,
                          child: Text("Apply Filter",style: TextStyle(color: secondaryColor),),
                          onPressed: (){
                            print(startDay);
                            if(startDay!="Start Date" && endDay!="End Date"){
                              if(convertString(endDay).compareTo(convertString(startDay))==1){
                                setMeta((){
                                  error=0;
                                });
                                setState(() {
                                  dateSelected=1;
                                  startDate=convertString(startDay);
                                  endDate=convertString(endDay);
                                  Navigator.pop(context);
                                });
                              }else{
                                setState(() {
                                  dateSelected=0;
                                });
                                setMeta((){
                                  error=1;
                                });
                              }
                            }
                            else{
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    )
                  ]
              );
            },
          ),
        );
      },
    );
  }
}

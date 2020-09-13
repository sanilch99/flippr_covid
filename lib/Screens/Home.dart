import 'package:flippr_covid/Screens/Contact.dart';
import 'package:flippr_covid/Screens/Dashboard.dart';
import 'package:flippr_covid/Screens/Notifications.dart';
import 'package:flippr_covid/Screens/PatientDemographic.dart';
import 'package:flippr_covid/models/ConfirmedCases.dart';
import 'package:flippr_covid/utils/api.dart';
import 'package:flippr_covid/utils/colors.dart';
import 'package:flippr_covid/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<ConfirmedCases> cc;
  String totalToday;
  String yesterday;
  String twoDayBefore;
  String threeDaysAgo;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cc=getConfirmedCases();
    cc.then((value){
      for(Datum d in value.data){
        print(d.day.toIso8601String().substring(0,10));
        if(d.day.toIso8601String().substring(0,10)==convertDateDiff(DateTime.now())){
          setState(() {
            totalToday=d.summary.total.toString();
          });
        }else{
          setState(() {
            totalToday="Not Updated Yet";
          });
        }
        print("${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day-1}");
        if(d.day.toIso8601String().substring(0,10)==convertDateDiff(DateTime.now().subtract(new Duration(days: 1)))){
          setState(() {
            yesterday=d.summary.total.toString();
          });
        }
        if(d.day.toIso8601String().substring(0,10)==convertDateDiff(DateTime.now().subtract(new Duration(days: 2)))){
          setState(() {
            twoDayBefore=d.summary.total.toString();
          });
        }
        if(d.day.toIso8601String().substring(0,10)==convertDateDiff(DateTime.now().subtract(new Duration(days: 3)))){
          setState(() {
            threeDaysAgo=d.summary.total.toString();
          });
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            "CovidHelper",
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 24,fontStyle: FontStyle.italic
            ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline,color: secondaryColor,),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      backgroundColor: secondaryColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hi Judges/Devs At Flipr.ai,\n\nMy name is Sanil Chawla,this application is my submission for the hackathon,have a look at the github page to see some hidden extra features that were not requested',
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              fontSize: 20
                            ),
                          )
                        ],
                      ),
                      actions: [
                        RaisedButton(
                          color: primaryColor,
                          child: Row(
                            children: [
                              Text("Github",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                    color: secondaryColor,
                                    fontSize: 20
                                ),),
                              Icon(
                                Icons.launch,color: secondaryColor,
                              )
                            ],
                          ),
                          onPressed: (){
                            launch("https://github.com/sanilch99/flippr_covid");
                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          color: primaryColor,
                          child: Text("Okay",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              color: secondaryColor,
                              fontSize: 20
                          ),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
              );
            },
          )
        ],
        backgroundColor: primaryColor
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.3,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(8),
            child: Card(
              elevation: 5,
              color: secondaryColor,
              child: (threeDaysAgo!=null &&  yesterday!=null && twoDayBefore!=null)?
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.175,
                    child: Card(
                      color: primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total Cases As Of Today',
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          totalToday!=null?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              totalToday!=null?totalToday:"Loading",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,fontStyle: FontStyle.italic
                              ),
                            ),
                          ):Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.31,
                        height: MediaQuery.of(context).size.height*0.095,
                        child: Card(
                          color: lightPrimaryColor,
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${DateTime.now().year}/0${DateTime.now().month}/${DateTime.now().day-3}",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              threeDaysAgo!=null?Text(
                                threeDaysAgo!=null?threeDaysAgo:"Loading",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,fontStyle: FontStyle.italic
                                ),
                              ):Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.31,
                        height: MediaQuery.of(context).size.height*0.095,
                        child: Card(
                          color: lightPrimaryColor,
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${DateTime.now().year}/0${DateTime.now().month}/${DateTime.now().day-2}",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                                ),
                              ),
                              twoDayBefore!=null?Text(
                                twoDayBefore!=null?twoDayBefore:"Loading",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,fontStyle: FontStyle.italic
                                ),
                              ):Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.31,
                        height: MediaQuery.of(context).size.height*0.095,
                        child: Card(
                          color: lightPrimaryColor,
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${DateTime.now().year}/0${DateTime.now().month}/${DateTime.now().day-1}",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              yesterday!=null?Text(
                                yesterday!=null?yesterday:"Loading",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,fontStyle: FontStyle.italic
                                ),
                              ):Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ):Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (context)=>Contact()));
                  },
                  child: Card(
                    color: secondaryColor,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Image.asset("assets/helpline.png",fit: BoxFit.contain,),
                        ),
                        Text(
                          'Contact & Helplines Information',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (context)=>NotificationsScreen()));
                  },
                  child: Card(
                    color: secondaryColor,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Image.asset("assets/notification.png",fit: BoxFit.contain,),
                        ),
                        Text(
                          'Notifications & Advisory',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (context)=>Dashboard()));
                  },
                  child: Card(
                    color: secondaryColor,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Image.asset("assets/dashboard.png",fit: BoxFit.contain,),
                        ),
                        Text(
                          'Dashboards',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>PatientDemographic()));
                  },
                  child: Card(
                    color: secondaryColor,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Image.asset("assets/graph.png",fit: BoxFit.contain,),
                        ),
                        Text(
                          'Graphical Analysis',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flippr_covid/models/Contacts.dart';
import 'package:flippr_covid/models/Hospital.dart';
import 'package:flippr_covid/models/MedicalCollege.dart';
import 'package:flippr_covid/utils/api.dart';
import 'package:flippr_covid/utils/colors.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin{
  Future<MedicalCollege> mc;
  List<MedicalCollegeElement> r;
  Future<Hospital> hc;
  List<Summary> s;
  String allState="[a-zA-Z]";
  String ddVal="All";
  String ddValTwo="All";
  RegExp state=RegExp("[a-zA-Z]");
  Ownership curr;
  int selected=0;
  int _selectedIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mc=getMedicalColleges();
    hc=getHospitals();
    _tabController=TabController(vsync: this,length: 2,initialIndex: _selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            _selectedIndex==0?"Hospital ":"Medical Colleges",
            style: TextStyle(
              color: secondaryColor,fontStyle: FontStyle.italic
            ),
          ),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: secondaryColor,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            Visibility(
              visible: _selectedIndex==0,
              child: IconButton(
                icon: Icon(Icons.sort,color: secondaryColor,),
                onPressed: (){
                  _showDialog(context);
                },
              ),
            )
          ],
          backgroundColor: primaryColor),
      backgroundColor:primaryColor ,
      body:TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.075,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: secondaryColor)),
                    color: secondaryColor,
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width:MediaQuery.of(context).size.width*0.15,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                          child: Text(
                            "State",
                            style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            softWrap: true,
                          ),
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.25,
                        child: Text(
                          "Institute Name",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.15,
                        child: Text(
                          "City",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.15,
                        child: Text(
                          "Type",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.12,
                        child: Text(
                          "Adm. Cap.",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.12,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,4,0),
                          child: Text(
                            "Hosp. Beds",
                            style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: FutureBuilder<MedicalCollege>(
                    future: mc,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        r = snapshot.data.data.medicalColleges.where((element) => state.hasMatch(element.state)).toList();
                        if(selected==1){
                          r=r.where((element) => element.ownership==curr).toList();
                        }
                        return RefreshIndicator(
                          backgroundColor: secondaryColor,
                          color: primaryColor,
                          onRefresh: _pullRefresh,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: r.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: secondaryColor,
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0,8.0,0,8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.15,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                                        child: Text(
                                          r[index].state,
                                          style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.25,
                                      child: Text(
                                        r[index].name,
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.15,
                                      child: Text(
                                        r[index].city,
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.16,
                                      child: Text(
                                        ownershipValues.reverse[r[index].ownership]!=null?ownershipValues.reverse[r[index].ownership]:"N/A",
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.12,
                                      child: Text(
                                        r[index].admissionCapacity.toString(),
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.12,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0,0,4,0),
                                        child: Text(
                                          r[index].hospitalBeds.toString(),
                                          style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(secondaryColor),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.075,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: secondaryColor)),
                    color: secondaryColor,
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width:MediaQuery.of(context).size.width*0.2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                          child: Text(
                            "State",
                            style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            softWrap: true,
                          ),
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.13,
                        child: Text(
                          "Rural Hosp.",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.13,
                        child: Text(
                          "Rural Beds",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.13,
                        child: Text(
                          "Urban Hosp.",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.13,
                        child: Text(
                          "Urban Beds ",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.13,
                        child: Text(
                          "Total Hosp.",
                          style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                          softWrap: true,
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width*0.13,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,4,0),
                          child: Text(
                            "Total Beds",
                            style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            softWrap: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: FutureBuilder<Hospital>(
                    future: hc,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        s= snapshot.data.data.regional;
                        return RefreshIndicator(
                          backgroundColor: secondaryColor,
                          color: primaryColor,
                          onRefresh: _pullRefresh,
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: s.length,
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: secondaryColor,
                                height: 10,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0,8.0,0,8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.2,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(4.0,0,0,0),
                                        child: Text(
                                          s[index].state!=null?s[index].state:"N/A",
                                          style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.13,
                                      child: Text(
                                        s[index].ruralHospitals.toString()!=null?s[index].ruralHospitals.toString():"N/A",
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.13,
                                      child: Text(
                                        s[index].ruralBeds.toString()!=null?s[index].ruralBeds.toString():"N/A",
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.13,
                                      child: Text(
                                        s[index].urbanHospitals.toString()!=null?s[index].urbanHospitals.toString():"N/A",
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.13,
                                      child: Text(
                                        s[index].urbanBeds.toString()!=null?s[index].urbanBeds.toString():"N/A",
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.13,
                                      child: Text(
                                        s[index].totalHospitals.toString()!=null?s[index].totalHospitals.toString():"N/A",
                                        style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                        softWrap: true,
                                      ),
                                    ),
                                    Container(
                                      width:MediaQuery.of(context).size.width*0.13,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0,0,4,0),
                                        child: Text(
                                          s[index].totalBeds.toString()!=null?s[index].totalBeds.toString():"N/A",
                                          style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(secondaryColor),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        elevation: 10,
        controller: _tabController,
        color: secondaryColor,
        activeColor: secondaryColor,
        backgroundColor: primaryColor,
        items: [
          TabItem(icon: Icons.local_hospital, title: 'Hospitals'),
          TabItem(icon: Icons.school, title: 'Medical Colleges'),
        ],
        initialActiveIndex: 0,//optional, default as 0
        onTap: (int i) {
          setState(() {
            _selectedIndex=i;
          });
        },
      ),
    );
  }

  Future _showDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          contentPadding: EdgeInsets.all(4),
          backgroundColor: secondaryColor,
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
                                fontSize: 20,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold
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
                                  fontSize: 20,fontStyle: FontStyle.italic
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
                                  "Sikkim","Tamil Nadu","Telangana","Tripura","Uttar Pradesh","Uttarakhand","West Bengal","A & N Islands","Chandigarh",
                                  "Dadra and Nagar Haveli","Daman and Diu","Lakshadweep","Delhi","Puducherry"].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),),
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
                                "Type",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20,fontStyle: FontStyle.italic
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new DropdownButton<String>(
                                dropdownColor: primaryColor,
                                value: ddValTwo,
                                items: <String>['All','Govt.', 'Trust', 'Society', 'University','Private'].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value,style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    if(val!="All"){
                                      selected=1;
                                      curr=ownershipValues.map[val];
                                    }else{
                                      selected=0;
                                    }
                                  });
                                  setMeta((){
                                    ddValTwo=val;
                                  });
                                },
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
                            Navigator.pop(context);
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

  Future<void> _pullRefresh() async{
    setState(() {
      mc=getMedicalColleges();
      hc=getHospitals();
    });
  }
}

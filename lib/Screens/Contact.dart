import 'package:flippr_covid/models/Contacts.dart';
import 'package:flippr_covid/utils/api.dart';
import 'package:flippr_covid/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  Future<Contacts> cc;
  List<Regional> r;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cc = getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
          titleSpacing: 0,
          elevation: 10,
          title: Text(
            "Contact & Helpline Information",
            style: TextStyle(
                color: secondaryColor,fontStyle: FontStyle.italic
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: secondaryColor,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          backgroundColor: primaryColor),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:MediaQuery.of(context).size.width*0.6,
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Location",
                        style: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width*0.4,
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Helpline",
                        style: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              child: FutureBuilder<Contacts>(
                future: cc,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    r = snapshot.data.data.contacts.regional;
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
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width:MediaQuery.of(context).size.width*0.6,
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  r[index].loc,
                                  style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                ),
                              ),
                              Container(
                                width:MediaQuery.of(context).size.width*0.4,
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  onTap:(){
                                    launch("tel://${r[index].number.contains(',')?r[index].number.substring(0,r[index].number.indexOf(",")):r[index].number}");
                                  },
                                  child: Text(
                                    r[index].number,
                                    style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
  Future<void> _pullRefresh() async{
    setState(() {
      cc = getContacts();
    });
  }
}

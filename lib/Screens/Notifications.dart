import 'package:flippr_covid/models/Notifications.dart' as ns;
import 'package:flippr_covid/utils/api.dart';
import 'package:flippr_covid/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationsScreen> {
  Future<ns.Notifications> cc;
  List<ns.Notification> r;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cc = getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    var unescape = new HtmlUnescape();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
          elevation: 10,
          titleSpacing: 0,
          title: Text(
            "Notifications",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: secondaryColor,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.05,
                        width: MediaQuery.of(context).size.width * 0.275,
                        child: Text(
                          "Date",
                          style: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                        ),
                        padding: EdgeInsets.only(left:8,bottom: 8, top: 8),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height*0.05,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          "Title",
                          style: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                        ),
                        padding: EdgeInsets.only(bottom: 8, top: 8),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    color: secondaryColor,
                    child: Text(
                      "Links",
                      style: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                    ),
                    padding: EdgeInsets.only(bottom: 8, top: 8,left: 32),
                  ),
                ),
              ],
            ),
            Flexible(
              child: FutureBuilder<ns.Notifications>(
                future: cc,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    r = snapshot.data.data.notifications;
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
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.275,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      r[index].title.contains("2020")
                                          ? r[index].title.substring(0, 11)
                                          : "N/A",
                                      style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      r[index].title.contains("2020")
                                          ? r[index].title.substring(11)
                                          : unescape.convert(r[index].title),
                                      style: TextStyle(color: secondaryColor,fontStyle: FontStyle.italic),
                                    ),
                                    padding: EdgeInsets.only(bottom: 8, top: 8),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.link,
                                  color: secondaryColor,
                                ),
                                onPressed: () {
                                  launch(r[index].link);
                                },
                              )
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(secondaryColor),
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
      cc = getNotifications();
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoundList extends StatefulWidget {
  @override
  _FoundListState createState() => _FoundListState();
}

class _FoundListState extends State<FoundList> {
  String why;
  String whydesc;
  String whykind;
  String whymodel;
  String whybrand;
  String whyreason;
  List<String> foundby = [];
  String foundwhere;
  String foundtime;

  getHolder() {
    // var firestore = FirebaseFirestore.instanceFor();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> qn = _firestore.collection("found").snapshots();
    return qn;
  }

  fetchVehicleInfo(String index) async {
    QuerySnapshot search = await FirebaseFirestore.instance.collection('found').where('query', isEqualTo: index).get();
    search.docs.forEach((element) {
      why = element.data()['query'];
      whydesc = element.data()['vehicledesc'];
      whykind = element.data()['vehiclekind'];
      whymodel = element.data()['vehiclemodel'];
      whybrand = element.data()['vehiclebrand'];
      whyreason = element.data()['reason'];
      // foundby = element.data()['foundby'];
      foundby.add(element.data()['foundby'].toString());
      foundwhere = element.data()['foundwhere'];
      foundtime = element.data()['foundtime'].toDate().toString();
      print(element.data()['query']);
    });

    showAlertDialog(BuildContext context) {
      Widget continueButton = FlatButton(
        child: Text("Ok"),
        onPressed: () {
          // sendData();
          Get.back();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(index),
        content: Text(
          '''
The given description for this vehicle:
$whydesc


With the following specification: 
$whykind
$whybrand
$whymodel


Vehicle was found by:
$foundby
While on the mission: 
$foundwhere
at:
$foundtime
                                                                              ''',
          maxLines: 20,
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
        actions: [
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(context);
  }

  foundlist() {
    ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    return Container(
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 5, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Found List",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: 'Nunito-Bold',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // _secondShow ? _showSearchList() : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0, left: 12, right: 12, bottom: 20),
                  child: Container(
                    width: 480,
                    // height: Get.height,
                    child: Column(
                      children: [
                        Container(
                          height: 400,
                          // width: Get.height,
                          color: Colors.white,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: getHolder(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('');
                              } else if (snapshot.connectionState == ConnectionState.done) {
                                return Text('');
                              } else {
                                if (snapshot.data == null) {
                                  return Text('');
                                } else {
                                  return Container(
                                    height: Get.height,
                                    child: ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (_, index) {
                                        return Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 18.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, right: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  color: Colors.white,
                                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30, spreadRadius: 5)],
                                                ),
                                                child: ListTile(
                                                  leading: Container(padding: EdgeInsets.all(8.0), child: Text(snapshot.data.docs[index]['vehicle'])
                                                      // CircleAvatar(
                                                      //   backgroundImage: NetworkImage(userList[index]["picUrl"]),
                                                      // ),
                                                      ),
                                                  title: Text(snapshot.data.docs[index]["vehiclebrand"]),
                                                  subtitle: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 0.0),
                                                          child: Text(
                                                            snapshot.data.docs[index]["vehiclemodel"],
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    fetchVehicleInfo(snapshot.data.docs[index]['vehicle']);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        child: foundlist(),
      ),
    );
  }
}

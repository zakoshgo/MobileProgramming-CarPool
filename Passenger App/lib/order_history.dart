import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project/reusable/reusable_methods.dart';

import 'Test_file/GlobalVariableForTesting.dart';
class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late DatabaseReference routeref;
  late DatabaseReference _usersAssignedReference;
  List<Map<String, String>> mapRoutes = [];

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController timeController = TextEditingController();


  ReusableMethods rm = ReusableMethods();
  late String currentdate;
  late String currentTime;

  void initState() {
    super.initState();
    routeref = FirebaseDatabase.instance.ref().child("routes");
    _usersAssignedReference = FirebaseDatabase.instance.ref().child("routes/TotalPassengersAssigned");

    currentdate = rm.getFormattedDateTimeWithoutSeconds().split(" ")[0];
    currentTime = rm.getFormattedDateTimeWithoutSeconds().split(" ")[1];


    _setupDataListener();
  }

  void _setupDataListener() {
    routeref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("Retrieved Data: ${event.snapshot.value}");

        // The retrieved data is a map, convert entries to a list
        var data = (event.snapshot.value as Map<dynamic, dynamic>).entries;

        if (data != null) {
          setState(() {
            mapRoutes = data
                .where((entry) {
              // Filter based on TotalPassengersAssigned for the current user
              var totalPassengersAssigned =
              entry.value['TotalPassengersAssigned'] as Map?;
              if(TESTMODE == 0){
                return totalPassengersAssigned != null && totalPassengersAssigned.containsKey(FirebaseAuth.instance.currentUser?.uid);
              }
              else{
                return totalPassengersAssigned != null && totalPassengersAssigned.containsKey("TEST");
              }

            })
                .map((entry) =>
            Map<String, String>.from({
              'From': '${entry.value['From']}',
              'To': '${entry.value['To']}',
              'Time': '${entry.value['Time']}',
              'RoutID': '${entry.value['RoutID']}',
              "price": '${entry.value['price']}',
              "Date":'${entry.value['Date']}',
              "TripStatus": '${entry.value['TripStatus']}',
              "Passengers":'${entry.value['Passengers']}',
            }))
                .toList();
          });
        }
      } else {
        print("Snapshot value is null");
      }
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order history'),
      ),

      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mapRoutes.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(

                      color: Colors.blueAccent,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("From:${mapRoutes[index]['From']}",
                              style: TextStyle(fontSize: 12),),
                            Text("Time:${mapRoutes[index]['Time']} ${mapRoutes[index]['Date']}"),
                            Text("To:${mapRoutes[index]['To']}"),
                            Text("Status:${mapRoutes[index]["TripStatus"]}"),

                          ],
                        ),
                        leading: Image.asset(
                          "assets/images/car-sharing.png",
                          height: 25,
                        ),
                        onTap: () async{



                          if(currentTime.compareTo("23:29")>0 && mapRoutes[index]["Time"] == "7:30"  && currentdate.compareTo(mapRoutes[index]["Date"].toString()) <0 && mapRoutes[index]["Passengers"]!="null"){
                            print("the ride in the next day but the clock is after 11:30 PM");
                            var partTwo = mapRoutes[index]["Passengers"].toString().split(":")[0].split("{")[1];
                            Map<String,dynamic> myMap={partTwo:partTwo};
                            await routeref.child(mapRoutes[index]["RoutID"]!).child("rejectedPassengers").update(myMap);
                            await routeref.child(mapRoutes[index]["RoutID"]!).child("Passengers").remove();
                            setState(() {

                            });
                          }
                          print(mapRoutes[index]["Passengers"]?.isNotEmpty);
                          print(mapRoutes[index]["Passengers"]);
                          if(currentdate.compareTo(mapRoutes[index]["Date"].toString()) >= 0 && mapRoutes[index]["Passengers"].toString()!="null"){
                            print("the ride is 7:30 and we are after 12AM in the Same day or the ride is in the past");
                            print(mapRoutes[index]["Passengers"]);
                            var partTwo = mapRoutes[index]["Passengers"].toString().split(":")[0].split("{")[1];
                            Map<String,dynamic> myMap={partTwo:partTwo};
                            await routeref.child(mapRoutes[index]["RoutID"]!).child("rejectedPassengers").update(myMap);
                            await routeref.child(mapRoutes[index]["RoutID"]!).child("Passengers").remove();
                            setState(() {

                            });
                          }
                          if(currentTime.compareTo("16:29")>0 && mapRoutes[index]["Time"] == "17:30"  && currentdate.compareTo(mapRoutes[index]["Date"].toString()) == 0 && mapRoutes[index]["Passengers"]!="null"){
                            print("the ride in the same day but the clock is after 4:29 PM");
                            var partTwo = mapRoutes[index]["Passengers"].toString().split(":")[0].split("{")[1];
                            Map<String,dynamic> myMap={partTwo:partTwo};
                            await routeref.child(mapRoutes[index]["RoutID"]!).child("rejectedPassengers").update(myMap);
                            await routeref.child(mapRoutes[index]["RoutID"]!).child("Passengers").remove();
                            setState(() {

                            });
                          }



                          Navigator.pushNamed(context,
                              "/order_tracking_page",
                              arguments: {
                                "RoutID": "${mapRoutes[index]['RoutID']}"
                              }
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
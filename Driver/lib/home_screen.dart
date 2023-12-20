import 'package:driver_app/reusable/reusable_methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Test_file/GlobalVariableForTesting.dart';
void main() {
  runApp(MyScreen());
}

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late DatabaseReference routeref;
  List<Map<String, String>> mapRoutes = [];
  late String? currentDriverID;

  ReusableMethods rm = ReusableMethods();
  late String currentdate;
  late String currentTime;


  bool TWENTY_ONE_THERTY_FLAG = false;
  bool TWENTY_TWO_THERTY_FLAG = false;
  bool TWELVE_THERTY_FLAG = false;
  bool THIRTEEN_THERTY_FLAG = false;
  bool ONE_THERTY_FLAG = false;
  bool DEFAULT_FLAG = true;

  void initState() {
    super.initState();
    //routeref = FirebaseDatabase.instance.reference().child("routes");
    routeref = FirebaseDatabase.instance.ref("routes");
    _setupDataListener();

    if(TESTMODE == 0){
      currentDriverID = FirebaseAuth.instance.currentUser?.uid;
    }
    else{
      currentDriverID = "TEST";
    }


    print(currentDriverID);

    currentdate = rm.getFormattedDateTimeWithoutSeconds().split(" ")[0];
    currentTime = rm.getFormattedDateTimeWithoutSeconds().split(" ")[1];
    print(TESTMODE);
  }

  void _setupDataListener() {
    routeref.onValue.listen((event) {
      if (event.snapshot.value != null) {
        print("Retrieved Data: ${event.snapshot.value}");

        // The retrieved data is a map, convert entries to a list
        var data = (event.snapshot.value as Map<dynamic, dynamic>)?.entries;

        if (data != null) {

          setState(() {
            mapRoutes = data
                .where((entry)=>entry.value['DriverID'] == currentDriverID)
                .map((entry) => Map<String, String>.from({
              'From': '${entry.value['From']}',
              'To': '${entry.value['To']}',
              'Time': '${entry.value['Time']}',
              'RoutID':'${entry.value['RoutID']}',
              "Date":'${entry.value['Date']}',
              "price":  '${entry.value['price']}',
              "TripStatus":'${entry.value['TripStatus']}',
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



  printTimeFlags(){
    print("TWENTY_ONE_THERTY_FLAG:${TWENTY_ONE_THERTY_FLAG}");
    print("TWENTY_TWO_THERTY_FLAG:${TWENTY_TWO_THERTY_FLAG}");
    print("TWELVE_THERTY_FLAG:${TWELVE_THERTY_FLAG}");
    print("THIRTEEN_THERTY_FLAG:${THIRTEEN_THERTY_FLAG}");
    print("ONE_THERTY_FLAG:${ONE_THERTY_FLAG}");
    print("DEFAULT:${DEFAULT_FLAG}");
    _setupDataListener();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
      ),
      drawer: _buildSideDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
        Navigator.pushNamed(context, "/add_ride");

        },
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("time to bypass for testing"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (){
                    TWENTY_ONE_THERTY_FLAG = true;
                    TWENTY_TWO_THERTY_FLAG = false;
                    TWELVE_THERTY_FLAG = false;
                    THIRTEEN_THERTY_FLAG = false;
                    ONE_THERTY_FLAG = false;
                    DEFAULT_FLAG = false;
                    printTimeFlags();
                  },
                  child:Text("21:30",style: TextStyle(fontSize: 15),),
                ),
                ElevatedButton(
                  onPressed: (){
                    TWENTY_ONE_THERTY_FLAG = false;
                    TWENTY_TWO_THERTY_FLAG = true;
                    TWELVE_THERTY_FLAG = false;
                    THIRTEEN_THERTY_FLAG = false;
                    ONE_THERTY_FLAG = false;
                    DEFAULT_FLAG = false;
                    printTimeFlags();
                  },
                  child:Text("22:30",style: TextStyle(fontSize: 15),),
                ),
                ElevatedButton(
                  onPressed: (){
                    TWENTY_ONE_THERTY_FLAG = false;
                    TWENTY_TWO_THERTY_FLAG = false;
                    TWELVE_THERTY_FLAG = true;
                    THIRTEEN_THERTY_FLAG = false;
                    ONE_THERTY_FLAG = false;
                    DEFAULT_FLAG = false;
                    printTimeFlags();
                  },
                  child:Text("12:30",style: TextStyle(fontSize: 15),),
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: (){
                    TWENTY_ONE_THERTY_FLAG = false;
                    TWENTY_TWO_THERTY_FLAG = false;
                    TWELVE_THERTY_FLAG = false;
                    THIRTEEN_THERTY_FLAG = true;
                    ONE_THERTY_FLAG = false;
                    DEFAULT_FLAG = false;
                    printTimeFlags();
                  },
                  child:Text("13:30",style: TextStyle(fontSize: 15),),
                ),
                ElevatedButton(
                  onPressed: (){
                    TWENTY_ONE_THERTY_FLAG = false;
                    TWENTY_TWO_THERTY_FLAG = false;
                    TWELVE_THERTY_FLAG = false;
                    THIRTEEN_THERTY_FLAG = false;
                    ONE_THERTY_FLAG = true;
                    DEFAULT_FLAG = false;
                    printTimeFlags();
                  },
                  child:Text("1:30",style: TextStyle(fontSize: 15),),
                ),
                ElevatedButton(
                  onPressed: (){
                    TWENTY_ONE_THERTY_FLAG = false;
                    TWENTY_TWO_THERTY_FLAG = false;
                    TWELVE_THERTY_FLAG = false;
                    THIRTEEN_THERTY_FLAG = false;
                    ONE_THERTY_FLAG = false;
                    DEFAULT_FLAG = true;
                    printTimeFlags();
                  },
                  child:Text("default",style: TextStyle(fontSize: 15),),

                ),
              ],
            ),
            TWENTY_ONE_THERTY_FLAG?Text("Time is 21:30"):
            TWENTY_TWO_THERTY_FLAG?Text("Time is 22:30"):
            TWELVE_THERTY_FLAG?Text("Time is 12:30"):
            THIRTEEN_THERTY_FLAG?Text("Time is 13:30"):
            ONE_THERTY_FLAG?Text("Time is 1:30"):
            Text("default Time"),

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
                            Text("From:${mapRoutes[index]['From']}",style: TextStyle(fontSize: 12),),
                            Text("Time:${mapRoutes[index]['Time']} ${mapRoutes[index]['Date']}"),
                            Text("To:${mapRoutes[index]['To']}"),
                            Text("Status:${mapRoutes[index]["TripStatus"]}"),
                            Text("Price:${mapRoutes[index]["price"]}"),
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

                          Navigator.pushNamed(context, "/rideTracking",arguments: {"RoutID": "${mapRoutes[index]['RoutID']}"});
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }

  Drawer _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem(context, 'Profile Page', '/Profile_screen'),
          _buildDrawerItem(context, 'Logout', '/Login_screen'),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        if (title != 'Logout')
        {
          Navigator.pop(context); // Close the drawer
          Navigator.pushNamed(context, route);
        }
        else{
          Navigator.pop(context); // Close the drawer
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, route);
        }

      },
    );
  }
}

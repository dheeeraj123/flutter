import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireConnect extends StatefulWidget {
  const FireConnect({Key? key}) : super(key: key);

  @override
  State<FireConnect> createState() => _FireConnectState();
}

class _FireConnectState extends State<FireConnect> {
  TextEditingController namecontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();

  sentData()async{
   await FirebaseFirestore.instance.collection("Data").add({
      "name":namecontroller.text,
      "password":passwordcontroller.text,
    });
  }
  var nameList=[];
  getData()async{
   var filldetials = await FirebaseFirestore.instance.collection("Data").get();
  // var name =  filldetials.docs[0].data()["name"];
  setState(() {
    nameList=filldetials.docs;
  });



  }
  DeleteData(String id)async{
    var delData=await FirebaseFirestore.instance.collection("Data").doc(id).delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FIRE BASE"), backgroundColor: Colors.yellow),
      body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                    cursorColor: Colors.red,
                    decoration: InputDecoration(fillColor: Colors.blueGrey,filled: true,label: Text("name")
                    ),
                    controller: namecontroller),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(controller: passwordcontroller,
                    decoration: InputDecoration(fillColor: Colors.blue,filled: true,label: Text("password")
                ),
                ),
              ),

              FloatingActionButton(onPressed: (){
              sentData();
              }),
              FloatingActionButton(onPressed: (){
              getData();
              }),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount:nameList.length,
              //     itemBuilder: (context,index) {
              //       return Container(
              //         color: Colors.green,
              //         height:80,
              //         width:MediaQuery.of(context).size.width ,
              //         child: Padding(
              //           padding: const EdgeInsets.only(left: 50),
              //           child: Text(
              //             nameList[index].data()["name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
              //           ),
              //         ),
              //       );
              //     }
              //   ),
              // ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Data").snapshots(),
                  builder: (context,snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount:snapshot.data!.docs.length,
                          itemBuilder: (context,index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: Colors.green,
                                height:80,
                                width:MediaQuery.of(context).size.width ,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index].data()["name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                                    ),
                                    IconButton(onPressed: (){
                                      DeleteData(snapshot.data!.docs[index].id);
                                    }, icon: Icon(Icons.deblur))
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }else{
                      return Text("no data");
                    }

                  }
                ),
              ),

          ],)
      ),


    );
  }
}


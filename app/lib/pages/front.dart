import 'dart:convert';
import 'package:he_fish/pages/login.dart';
import 'package:he_fish/pages/fish_category.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:he_fish/constants.dart';
import 'package:http/http.dart';
import 'package:he_fish/components/fishtypeslist.dart';
import 'package:he_fish/model/fishtype_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrontPage extends StatefulWidget {
  static String tag = 'front-page';
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  int uid = 0;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getPref() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final int? id = prefs.getInt('id');
    setState(() {
      uid == id;
    });
  }

  Container GradientContainer(Size size) {
    return Container(
      height: size.height * .3,
      width: size.width,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100)),
          image: DecorationImage(
              image: AssetImage('assets/images/fish.jpg'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100)),
            gradient: LinearGradient(colors: [
              secondaryColor.withOpacity(0.9),
              primaryColor.withOpacity(0.9)
            ])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = TextButton(
        child: Text("Continue"),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Logout Confirmation"),
        content: Text("Are you sure you want to logout ?"),
        actions: [
          cancelButton,
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

    final List<String> imgList = [
      'https://images.squarespace-cdn.com/content/v1/552b8b01e4b0ee740dee0bf1/1614162260254-VS9XH1G63YW1RNS3OOZ6/BlueTang_Dory.jpg',
      'http://azure.wgp-cdn.co.uk/app-practicalfishkeeping/features/4c5938a971f72.jpg?&width=1200&height=630&mode=crop&format=webp&webp.quality=40&scale=both',
      'https://images.squarespace-cdn.com/content/v1/552b8b01e4b0ee740dee0bf1/1615173099007-VD92CHZHW5BQB94VLTSR/Mandarin+Asli',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaC3b9tbwWwHt20YPcJdFNV3fRABC6yczzLQ&usqp=CAU'
    ];
    return Builder(builder: (context) {
      return Scaffold(
          backgroundColor: Color(0xfff5f7fa),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(height: size.height * .4, width: size.width),
                    GradientContainer(size),
                    Container(
                      margin: const EdgeInsets.fromLTRB(4, 50, 10, 10),
                      decoration: BoxDecoration(),
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  // padding: EdgeInsets.only(top: 0),
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                          image: AssetImage(
                                              "assets/images/logo_hefish.png")))),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Welcome to",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  Text("HE FISH",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40))
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                              // color: Colors.amber,
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    showAlertDialog(context);
                                  },
                                  icon: Icon(Icons.logout,
                                      color: Colors.white, size: 30)))
                        ],
                      ),
                    ),
                    Container(
                        // color: Colors.amber,
                        width: size.width,
                        height: 250,
                        margin: EdgeInsets.only(top: size.height * .17),
                        child: CarouselSlider(
                          options: CarouselOptions(
                              height: 200.0,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3)),
                          items: imgList.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    // padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 10),
                                            blurRadius: 20,
                                            color:
                                                Color.fromARGB(255, 73, 73, 73)
                                                    .withOpacity(0.7))
                                      ],
                                      color: Color.fromARGB(255, 243, 243, 241),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        item,
                                        fit: BoxFit.cover,
                                        height: 150.0,
                                        width: 100.0,
                                      ),
                                    ));
                              },
                            );
                          }).toList(),
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      Text("About HE Fish",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      Container(
                          // padding: EdgeInsets.only(top: 0),
                          width: 120.0,
                          height: 120.0,
                          decoration: new BoxDecoration(
                              image: new DecorationImage(
                                  image: AssetImage(
                                      "assets/images/logo_hefish.png")))),
                      Text(
                          "Founded by Henama Ea in 2001, HE Fish is a fish shop that have lists many popular decorative fish. We sell many fish from around the world.",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 70, 73, 75),
                          )),
                    ],
                  ),
                ),
                FishTypeList(),
                SizedBox(height: 40)
              ],
            ),
          ));
    });
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:he_fish/pages/fishes.dart';
import 'package:he_fish/pages/fish_category.dart';
import 'package:http/http.dart' as http;
import 'package:he_fish/constants.dart';
// import 'package:he_fish/model/fishtype_model.dart';

class FishTypeList extends StatelessWidget {
  Future<List<dynamic>> _fetchFishTypes() async {
    final String apiUrl = "${httpUrl}fishtypes/types/";
    var result = await http.get(Uri.parse(apiUrl));
    var data = jsonDecode(result.body.toString());
    // print(data['types']);
    return json.decode(result.body)['types'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        child: FutureBuilder<List<dynamic>>(
      future: _fetchFishTypes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Fish Category",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20))),
              Container(
                height: 150,
                // color: Colors.red,
                width: size.width / 1.07,
                // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                // decoration: BoxDecoration(padding),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 110,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Container(
                        // width: 240,
                        // height: 140,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 6,
                                  color: Color.fromARGB(255, 156, 156, 156)
                                      .withOpacity(0.4))
                            ],
                            color: Color.fromARGB(255, 231, 231, 231),
                            borderRadius: BorderRadius.circular(15)),
                        child: GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FishCategoryPage(
                                    categories: snapshot.data,
                                    categoryID: snapshot.data[index]["id"],
                                    categoryName: snapshot.data[index]
                                        ["name"])))
                          },
                          child: Container(
                              height: 60,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                snapshot.data[index]["name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              )),
                        ),
                      );
                    }),
              )
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}

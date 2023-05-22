import 'package:flutter/material.dart';
import 'package:http_response_handling/comedy_screen.dart';
import 'package:http_response_handling/models/categories_model.dart';
import 'package:http_response_handling/models/categories_model_data.dart';
import 'api_provider.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

//    https://api.chucknorris.io/
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ApiProvider _provider = ApiProvider();
  List<String> _list = [];
  CategoriesDetail _detail = CategoriesDetail();

  getcategories() async {
    var response = await _provider.get("jokes/categories");
    print("Added");
    setState(() {
      _list = categoriesFromJson(response.body);
      print("Done");
    });

    return "success";
  }

  getDetails(String category) async {
    var response = await _provider.get("jokes/random?category=" + category);
    setState(() {
      _detail = categoriesDetailFromJson(response.body);
    });
    return "success";
  }

  @override
  void initState() {
    super.initState();
    getcategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)), //getcategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.hasData) {
            return ListView.builder(
              itemCount: _list.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    await getDetails(_list[index]);
                    print("Okay");
                    if (_detail.categories![0] != null) {
                      print(_detail.categories![0]);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ComedyPage(name: _detail.categories![0]!)));
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(vertical: 2.5),
                      color: Colors.red,
                      child: Text(
                        _list[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

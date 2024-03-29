import 'package:flutter/material.dart';
import 'package:http_response_handling/comedy_screen.dart';
import 'package:http_response_handling/models/categories_model.dart';
import 'package:http_response_handling/models/categories_model_data.dart';
import 'api_provider.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

//    https://api.chucknorris.io/
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final ApiProvider _provider = ApiProvider();
  List<String> _list = [];
  CategoriesDetail _detail = CategoriesDetail();

  getcategories() async {
    var response = await _provider.get("jokes/categories");
    debugPrint("Added");
    setState(() {
      _list = categoriesFromJson(response.body);
      debugPrint("Done");
    });

    return "success";
  }

  getDetails(String category) async {
    var response = await _provider.get("jokes/random?category=$category");
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
        title: const Text("Home Page"),
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)), //getcategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.hasData) {
            return ListView.builder(
              itemCount: _list.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    await getDetails(_list[index]);
                    debugPrint("Okay");
                    if (_detail.categories![0] != null) {
                      debugPrint(_detail.categories![0]);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ComedyPage(name: _detail.categories![0]!)));
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.symmetric(vertical: 2.5),
                      color: Colors.red,
                      child: Text(
                        _list[index],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

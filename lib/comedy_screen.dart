import 'package:flutter/material.dart';
import 'package:http_response_handling/api_provider.dart';
import 'package:http_response_handling/models/categories_model_data.dart';

class ComedyPage extends StatefulWidget {
  final String? name;

  const ComedyPage({super.key, required this.name});
  @override
  ComedyPageState createState() => ComedyPageState();
}

class ComedyPageState extends State<ComedyPage> {
  final ApiProvider _provider = ApiProvider();
  CategoriesDetail _detail = CategoriesDetail();

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
    getDetails(widget.name!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name!),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Future.delayed(
              const Duration(seconds: 3)), //getDetails(widget.name!),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done ||
                snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(_detail.iconUrl!),
                  ),
                  //  Image.network(_detail.url!),
                  // Text(_detail.url!),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      _detail.value!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

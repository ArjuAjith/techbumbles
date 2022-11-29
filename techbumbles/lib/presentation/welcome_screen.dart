import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techbumbles/model/auth_data.dart';
import 'package:techbumbles/model/product_data.dart';
import 'package:techbumbles/repo.dart';

class WelcomePage extends StatefulWidget {
  final AuthData authData;
  const WelcomePage({Key? key, required this.authData}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool updating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Authdata view
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome ${widget.authData.username!},",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(widget.authData.image!),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(widget.authData.firstName!),
                                  SizedBox(width: 3),
                                  Text(widget.authData.lastName!),
                                ],
                              ),
                              Text(widget.authData.gender!),
                              Text(widget.authData.email!),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Product List,",
                style: TextStyle(fontSize: 20),
              ),
            ),

            FutureBuilder(
                initialData: [CircularProgressIndicator()],
                future: getProductsData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error occured!!!"),
                      );
                    } else {
                      // return Text("every think look good");
                      return getLoad(snapshot.data);
                    }
                  }
                  return Center(
                    child: Text("Something went wrong"),
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget getLoad(List<Products> list) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Products product = list[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.brand!,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(product.description!),
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }

  Future<List<Products>> getProductsData() async {
    final json = await DataService().getProducts();
    final data = productsList(json);
    // print(data[3].rating);
    return data;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'DetailViewBody.dart';
import 'package:shop_example/models/product.dart';

//import 'package:shop_example/screens/product_detail_screen.dart';
import 'package:shop_example/screens/product_screen.dart';

class GridHome extends StatefulWidget {
  const GridHome({Key? key}) : super(key: key);

  @override
  _GridHomeState createState() => _GridHomeState();
}

class _GridHomeState extends State<GridHome> {
  Future<List<Product>> fetchDataFromApi() async {
    final response = await http
        .get(Uri.parse('https://bworldapp.online/cfastapi/homelist.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      List<Product> products = jsonResponse.map((item) {
        return Product(
          title: item['title'],
          description: item['title'],
          image: item['image'],
          price: item['price'],
          date: item['date'],
          time: item['time'],
          itemUrl: item['itemUrl'], // Add other fields as needed.
          classID: item['classID'],
          location: item['location'],
        );
      }).toList();

      return products;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: fetchDataFromApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return StaggeredGridView.countBuilder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              return _buildGridItem(context, snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildGridItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductScreen(product: product)),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Color.fromARGB(255, 242, 245, 248),
          border: Border.all(
            color: Colors
                .black, // Replace this with the color you want for the border
            width: 2.0, // Adjust the width of the border as needed
          ),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Image.network(
                  product.image,
                  height: 200, // Example height
                  width: 200, // Example width
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.price.toString(),
                      style: Theme.of(context).textTheme.subtitle1!.merge(
                            const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      product.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2!.merge(
                            TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 12,
                            ),
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      product.location.toLowerCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2!.merge(
                            TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart'
    as http; // Import the http package for making HTTP requests.
import 'package:flutter/material.dart';
import 'package:shop_example/constants.dart';
//import 'package:shop_example/models/category.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/screens/product_grid.dart';
//import 'package:shop_example/widgets/GridB.dart';
import 'package:shop_example/widgets/GridHome.dart';
import 'package:shop_example/widgets/categories.dart';
import 'package:shop_example/widgets/home_appbar.dart';
//import 'package:shop_example/widgets/home_slider.dart';
import 'package:shop_example/widgets/product_card.dart';
import 'package:shop_example/widgets/search_field.dart';
import 'package:shop_example/widgets/product_widgets/appbar.dart';
import 'package:shop_example/widgets/trending_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0;
  late Future<List<Product>> products; // Declare the products list.

  @override
  void initState() {
    super.initState();
    products =
        fetchProductsFromAPI(); // Initialize the products list with API data.
  }

  // Function to fetch data from the API and create a list of Product objects.
  Future<List<Product>> fetchProductsFromAPI() async {
    // final response =
    //     await http.get('https://bworldapp.online/cfastapi/test.php' as Uri);

    final response = await http.get(Uri.parse(
        'http://194.233.164.182/plesk-site-preview/bworldapp.online/https/194.233.164.182/bworldapp/cfastapi/test.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<Product> products = [];

      for (var item in data) {
        final product = Product(
          title: item['title'],
          description: item['description'],
          image: item['image'],
          price: item['price'],
          date: item['date'],
          time: item['time'],
          itemUrl: item['itemUrl'], // Add other fields as needed.
          classID: item['classID'],
          location: item['location'],
        );

        products.add(product);
      }

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kscaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),
                const SizedBox(height: 20),
                const SearchField(),
                const SizedBox(height: 20),
                // HomeSlider(
                //   onChange: (value) {
                //     setState(() {
                //       currentSlide = value;
                //     });
                //   },
                //   currentSlide: currentSlide,
                // ),
                // const SizedBox(height: 20),
                const Categories(),
                const SizedBox(height: 5),
                // StaggeredGridViewWidget(),
                // const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 5.0), // Adjust the padding value as needed
                      child: Text(
                        "Trending",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("See all"),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const GridHome(),
                const SizedBox(height: 5),
                // Use a FutureBuilder to display products once they are loaded.
                // FutureBuilder<List<Product>>(
                //   future: products,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Center(child: CircularProgressIndicator());
                //     } else if (snapshot.hasError) {
                //       return Center(child: Text('Error: ${snapshot.error}'));
                //     } else {
                //       final productList = snapshot.data;
                //       return GridView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         shrinkWrap: true,
                //         gridDelegate:
                //             const SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 2,
                //           crossAxisSpacing: 20,
                //           mainAxisSpacing: 20,
                //         ),
                //         itemCount: productList?.length ?? 0,
                //         itemBuilder: (context, index) {
                //           final product = productList![index];
                //           return ProductCard(product: product);
                //         },
                //       );
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

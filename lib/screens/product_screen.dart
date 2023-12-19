import 'package:flutter/material.dart';
import 'package:shop_example/constants.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/widgets/product_widgets/CallButtonsBar.dart';
//import 'package:shop_example/models/products.dart';

import 'package:shop_example/widgets/product_widgets/ChatActionsWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

///import 'package:shop_example/widgets/product_widgets/add_to_cart.dart';
import 'package:shop_example/widgets/product_widgets/appbar.dart';
import 'package:shop_example/widgets/product_widgets/image_slider.dart';
import 'package:shop_example/widgets/product_widgets/information.dart';
import 'package:shop_example/widgets/product_widgets/product_desc.dart';
import 'package:shop_example/widgets/product_widgets/DescriptionWidget.dart';
import 'package:shop_example/widgets/GridB.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int currentImage = 0;
  bool isFavorite = false;

  Map<String, dynamic> productData = {};

  // Future<void> fetchData() async {
  //   Fluttertoast.showToast(
  //       msg: 'Top: ${widget.product.itemUrl}'); // Display toast message

  //   final response = await http.get(Uri.parse(widget.product.itemUrl));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       productData = json.decode(response.body);
  //     });
  //   } else {
  //     // Handle errors
  //     print('Failed to fetch data');
  //   }
  // }

  // Future<void> fetchData() async {
  //   try {
  //     ///final response = await http.get(Uri.parse('http://172.105.86.61/plesk-site-preview/api.cfast.ng/https/172.105.86.61/details.php?durl=${widget.product.itemUrl}'));
  //     final response = await http.get(Uri.parse(
  //         'http://172.105.86.61/plesk-site-preview/api.cfast.ng/https/172.105.86.61/pdetails.php?durl=${widget.product.classID}'));
  //     if (response.statusCode == 200) {
  //       setState(() async {
  //         productData = await json.decode(response.body);
  //       });
  //     } else {
  //       // Handle other status codes
  //       print('HTTP Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle other exceptions
  //     print('Exception during HTTP request: $e');
  //     Fluttertoast.showToast(msg: 'Top: $e');
  //   }
  // }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://172.105.86.61/plesk-site-preview/api.cfast.ng/https/172.105.86.61/pdetails.php?durl=${widget.product.classID}'));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        Fluttertoast.showToast(msg: response.body);
        setState(() {
          productData = decodedResponse;
        });
      } else {
        // Handle other status codes
        print('HTTP Error: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Result: ${response.statusCode}');
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Exception during HTTP request: $e');
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> sendOffer(String offer) async {
    // Simulated API call to send the offer
    // Replace this section with your actual API call logic
    // For example:
    if (offer.isNotEmpty) {
      // Simulating a successful API response
      await Future.delayed(Duration(seconds: 2)); // Simulating delay

      // Display a toast message based on the API response
      Fluttertoast.showToast(msg: 'Offer sent successfully: $offer');
    } else {
      Fluttertoast.showToast(msg: 'Please enter an offer amount');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              //title: Text(widget.product.title),
              background: Image.network(
                widget.product.image,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ],
            pinned: false,
            floating: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProductInfo(product: widget.product),
                  const SizedBox(height: 10),
                  // CallButtonsBar(
                  //   onRequestCallPressed: () {
                  //     // Handle request call button press
                  //   },
                  //   onMakeCallPressed: () {
                  //     // Handle make call button press
                  //   },
                  // ),
                  // CallButtonsBar widget usage
                  CallButtonsBar(
                    onRequestCallPressed: () {
                      // Handle request call button press
                      print('Request Call button pressed');

                      // Extract necessary information from productData
                      String storeName = productData['phone'];
                      String phoneNumber = productData['phone'];
                      String productTitle = productData['title'];

                      // Compose the email message
                      String emailBody =
                          'Hello $storeName, a user with phone number $phoneNumber would like you to return a call regarding $productTitle.';

                      // Encode the email body for URL
                      String encodedBody = Uri.encodeComponent(emailBody);

                      // Launch the default email client with a pre-filled email
                      launch('mailto:?body=$encodedBody');
                    },
                    onMakeCallPressed: () {
                      // Handle make call button press
                      print('Make Call button pressed');

                      // Extract the phone number from productData and initiate a call
                      String phoneNumber = '+2348129622590';
                      // Implement code to initiate a call using the obtained phone number
                      // For example, you might use a package like url_launcher to initiate the call

                      // Here is a basic implementation using url_launcher
                      // Example:
                      launch('tel:$phoneNumber');
                      // This will prompt the user to make a call to the specified phone number
                    },
                  ),

                  const SizedBox(height: 10),
                  ChatActionsWidget(
                    onMakeOfferPressed: () {
                      // Handle "Make an Offer" button press
                    },
                    onIsAvailablePressed: () {
                      // Handle "Is This Available" button press
                    },
                    onLastPricePressed: () {
                      // Handle "Last Price" button press
                    },
                    textEditingController: TextEditingController(),
                    onStartChatPressed: () {
                      // Handle "Start Chat" button press
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: "Posted By: "),
                            TextSpan(
                              text: productData['storeName'] ?? "Loading...",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          String enteredOffer = '';

                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Make an Offer',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Enter your bid',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          enteredOffer = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (enteredOffer.isNotEmpty) {
                                          await sendOffer(enteredOffer);
                                          Navigator.pop(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Please enter an offer amount');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.blue, // Background color
                                        onPrimary: Colors.white, // Text color
                                      ),
                                      child: Text('Send Offer'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                      onPrimary: Colors.white, // Text color
                    ),
                    child: Text('Make an Offer'),
                  ),
                  const SizedBox(height: 5),
                  // ExpandableDescriptionWidget(
                  //   description: productData['description'] ?? "Loading...",
                  // ),
                  // const SizedBox(height: 25),
                  Text(
                    productData['description'] ?? "Loading...",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          // Handle Mark Unavailable button press
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            BorderSide(color: Colors.blue),
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.blueAccent; // Color when pressed
                              }
                              return Colors.green; // Default color
                            },
                          ),
                        ),
                        child: Text(
                          'Mark \nUnavailable',
                          textAlign: TextAlign.center, // To center-align text
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          // Handle Report Abuse button press
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            BorderSide(color: Colors.red),
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.redAccent; // Color when pressed
                              }
                              return Colors.red; // Default color
                            },
                          ),
                        ),
                        child: Text(
                          'Report \nAbuse',
                          textAlign: TextAlign.center, // To center-align text
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  OutlinedButton(
                    onPressed: () {
                      // Handle 'Post ad like this' button press
                    },
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.green),
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.greenAccent; // Color when pressed
                          }
                          return Colors.blue; // Default color
                        },
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text('Post ad like this'),
                  ),

                  const SizedBox(height: 5),
                  const GridB(),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

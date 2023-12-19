import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Listing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddListingScreen(),
    );
  }
}

class AddListingScreen extends StatefulWidget {
  @override
  _AddListingScreenState createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  List<dynamic> _categories = [];
  List<dynamic> _subCategories = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _isLoading = false;

  String _selectedCategory = 'Category';
  String _selectedSubCategory = 'SubCategory';

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    String jsonString = await loadCategoriesData();
    setState(() {
      _categories = json.decode(jsonString)['strippedData'];
    });
  }

  Future<String> loadCategoriesData() async {
    return await rootBundle.loadString('assets/categories.json');
  }

  Future<void> loadSubCategories(int parentId) async {
    String apiUrl =
        'https://cfast.ng/api/categories?parentId=$parentId&nestedIncluded=0';

    try {
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Content-Language': 'en',
        'X-AppType': 'docs',
        'X-AppApiToken': 'WXhEdVFMT3VuVHRWTlFRQWQyMzdVSHN5ZnRZWlJEOEw='
      });
      if (response.statusCode == 200) {
        setState(() {
          _subCategories = json.decode(response.body)['result']['data'];
          _selectedSubCategory = _subCategories.isNotEmpty
              ? _subCategories[0]['id'].toString()
              : 'No Subcategory';
        });
      } else {
        print('Failed to load subcategories');
      }
    } catch (e) {
      print('Exception while loading subcategories: $e');
    }
  }

  void submitListing() async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://cfast.ng/api/posts'),
    );

    // Add headers
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Content-Language': 'en',
      'X-AppType': 'docs',
      'X-AppApiToken': 'WXhEdVFMT3VuVHRWTlFRQWQyMzdVSHN5ZnRZWlJEOEw='
    });

    // Get category ID from the selected subcategory
    var selectedSubCategoryId = _selectedSubCategory != 'SubCategory'
        ? _selectedSubCategory
        : '0'; // Replace with default value if needed

    // Add form fields
    request.fields.addAll({
      'category_id': selectedSubCategoryId,
      'package_id': '1',
      'country_code': 'NG',
      'email': 'liyam.espn@foundtoo.com',
      'phone': '+2348039474787',
      'phone_country': 'NG',
      'city_id': '167',
      'auth_field': 'email',
      'contact_name': 'Administrator',
      'accept_terms': 'true', // boolean value represented as string
      'title': _titleController.text,
      'description': _descriptionController.text,
      'tags': _tagsController.text,
      'price': _priceController.text, // New field for price
    });

    // Add image file
    if (_selectedImage != null) {
      var image =
          await http.MultipartFile.fromPath('pictures[]', _selectedImage!.path);
      request.files.add(image);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var decodedResponse = json.decode(responseBody);

        if (decodedResponse['success'] == true) {
          // Success toast and navigation to home screen
          Fluttertoast.showToast(msg: decodedResponse['message']);
          Navigator.of(context).pop(); // Navigate back to home screen
        } else {
          // Failure toast
          Fluttertoast.showToast(
              msg: 'Listing creation failed: ${decodedResponse['message']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Failure toast with status code
        // if (response.statusCode == 422) {
        //   print(await response.stream.bytesToString());
        //   Fluttertoast.showToast(msg: decodedResponse['message']);
        //   // Failure toast with status code
        //   Fluttertoast.showToast(
        //       msg:
        //           'Listing creation failed with status code: ${response.statusCode}');
        // }
        if (response.statusCode == 422) {
          final errorResponse = await response.stream.bytesToString();
          Fluttertoast.showToast(
              msg: 'Listing creation failed: $errorResponse');
        }
        // Fluttertoast.showToast(
        //     msg:
        //         'Listing creation failed with status code: ${response.statusCode}');
        // Print response body for debugging
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('Exception: $e');
      // Failure toast
      Fluttertoast.showToast(msg: 'Listing creation failed: $e');
    } finally {
      setState(() {
        _isLoading = false; // Set loading state to false after submission
      });
    }
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource
          .gallery, // Change to ImageSource.camera for taking a picture
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map<DropdownMenuItem<String>>((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'].toString(),
                    child: Text(category['name']),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                      _selectedSubCategory = 'SubCategory';
                      loadSubCategories(int.parse(newValue));
                    });
                  }
                },
                decoration: InputDecoration(labelText: 'Select Category'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedSubCategory,
                items:
                    _subCategories.map<DropdownMenuItem<String>>((subcategory) {
                  return DropdownMenuItem<String>(
                    value: subcategory['id'].toString(),
                    child: Text(subcategory['name']),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSubCategory = newValue;
                    });
                  }
                },
                decoration: InputDecoration(labelText: 'Select SubCategory'),
              ),
              SizedBox(height: 10),
              TextFormField(
                // Title input field
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                // Description input field
                controller: _descriptionController,
                maxLines: null, // Allows for multiple lines
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint:
                      true, // Aligns label with the multiline input
                  border: OutlineInputBorder(), // Optional, adds a border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                // Price input field
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                // Tags input field
                controller: _tagsController,
                decoration: InputDecoration(labelText: 'Tags'),
                // Validation or other configurations for tags input
              ),
              // Image preview
              if (_selectedImage != null) Image.file(_selectedImage!),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImage,
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // Button background color
                  onPrimary: Colors.white, // Text color
                ),
                child: Text(
                  'Select Image',
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    submitListing();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button background color
                  onPrimary: Colors.white, // Text color
                ),
                child: _isLoading
                    ? CircularProgressIndicator() // Loading indicator
                    : Text(
                        'Submit',
                        style: TextStyle(color: Colors.white), // Text color
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

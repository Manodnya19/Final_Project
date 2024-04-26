import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:food_app/pages/ImageConfirmationPage.dart';
import 'package:food_app/pages/NewBlankPage.dart';
import 'package:food_app/pages/bottom_bar.dart';
import 'package:food_app/pages/login_page.dart';
import 'package:food_app/pages/mlmodel.dart';
import 'package:food_app/pages/nav_bar.dart';
import 'package:food_app/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/pages/recepie.dart';
import 'package:food_app/widgets/background-image.dart';
import 'package:food_app/widgets/food.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class MyApp extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final MLModel mlModel = MLModel();
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _pickImageFromCamera(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      runModelOnImage(context, image);
    }
  }

  void runModelOnImage(BuildContext context, File image) async {
    // Load the ML model if not already loaded
    print('before model load function!!!!!!!!!!!!!!!!!!!!!!!!!');
    await Tflite.loadModel(
      model: "assets/images/model1.tflite",
      labels: "assets/images/classes.txt",
    );
    print('model loaded!!!!!!!!!!!!!!!!!!!!!!!!!');

    // Run the ML model on the captured image
    await mlModel.detectimage(image);
    String labelName = mlModel.v.split(',')[2];
    String finalName = labelName.split(' ')[2];

// Removing unnecessary characters
    finalName = finalName.replaceAll(']', ''); // Remove ']' character
    finalName = finalName.replaceAll('}', '');

// Updating finalName to store only 'samosa'
    finalName = finalName.replaceAll('_', ' ');

    // Navigate to the new blank page directly with the prediction result
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NewBlankPage(prediction: finalName),
    ));
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      runModelOnImage(context, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    String prediction = '';

    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage(),
      },
      home: Scaffold(
        backgroundColor: Colors.white, // Set main background color
        // extendBodyBehindAppBar: true,
        drawer: NavBar(
          auth: auth,
          displayName: user?.displayName ?? 'Guest',
          email: user?.email ?? '',
          //  backgroundColor: Color.fromARGB(255, 243, 243, 243),
        ), // Set background color for the entire screen
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
          backgroundColor: const Color.fromARGB(255, 28, 28, 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Stack(
          children: [
            // const BackgroundImage(), // Your existing background widget
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Color.fromARGB(
                    255, 255, 255, 255), // Overlay color for the entire screen
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome!',
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10), // Space between text and image
                            Image.asset(
                              'assets/images/logo1.png', // Replace with your logo image path
                              height: 50,
                              width: 50,
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Food Lookup',
                                    prefixIcon: Icon(Icons.search),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.arrow_forward),
                                      onPressed: () {
                                        prediction = _searchController
                                            .text; // Get value from search bar
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => NewBlankPage(
                                            prediction: prediction,
                                          ), // Navigate to the new blank page
                                        ));
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 49, 102, 49),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                10), // Add some space between "Welcome!" and the first container
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 243, 243, 243),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Capture or select an image of your food item to get nutritional information instantly.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: const Color.fromARGB(255, 28, 28, 28),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromARGB(
                                            255, 28, 28, 28),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 25),
                                      ),
                                      onPressed: () async {
                                        await _pickImageFromCamera(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.camera),
                                          SizedBox(width: 4),
                                          Text(
                                            'Camera',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                            255, 28, 28, 28),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(
                                            color: Colors
                                                .black, // Change border color here
                                            width: 2.0, // Set border width here
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 25),
                                      ),
                                      onPressed: () async {
                                        await _pickImageFromGallery(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.photo),
                                          SizedBox(width: 4),
                                          Text(
                                            'Gallery',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 243, 243, 243),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 10, bottom: 4),
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: InkWell(
                                onTap: () {
                                  // Handle onTap event
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/cartoon.png',
                                          width: 150, // Adjust size as needed
                                          height: 150,
                                        ),
                                        SizedBox(
                                            width:
                                                10), // Add some space between image and text
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Text(
                                                'Explore Popular \nItems Below',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 28, 28, 28),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          FoodWidget(
                                            imagePath:
                                                'assets/images/food_items/cake.jpg',
                                            label: 'Cake',
                                            onTap: () {
                                              prediction = 'Cake';
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NewBlankPage(
                                                        prediction: prediction),
                                              ));
                                            },
                                          ),
                                          SizedBox(width: 20),
                                          FoodWidget(
                                            imagePath:
                                                'assets/images/food_items/lasagna.jpg',
                                            label: 'Lasagna',
                                            onTap: () {
                                              prediction = 'Lasagna';
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NewBlankPage(
                                                        prediction: prediction),
                                              ));
                                            },
                                          ),
                                          SizedBox(width: 20),
                                          FoodWidget(
                                            imagePath:
                                                'assets/images/food_items/pie.jpg',
                                            label: 'Apple Pie',
                                            onTap: () {
                                              prediction = 'Apple Pie';
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NewBlankPage(
                                                        prediction: prediction),
                                              ));
                                            },
                                          ),
                                          SizedBox(width: 20),
                                          FoodWidget(
                                            imagePath:
                                                'assets/images/food_items/pizza.jpg',
                                            label: 'Pizza',
                                            onTap: () {
                                              prediction = 'Pizza';
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NewBlankPage(
                                                        prediction: prediction),
                                              ));
                                            },
                                          ),
                                          SizedBox(width: 20),
                                          FoodWidget(
                                            imagePath:
                                                'assets/images/food_items/samosa.jpg',
                                            label: 'Samosa',
                                            onTap: () {
                                              prediction = 'Samosa';
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NewBlankPage(
                                                        prediction: prediction),
                                              ));
                                            },
                                          ),
                                          SizedBox(width: 20),
                                          FoodWidget(
                                            imagePath:
                                                'assets/images/food_items/wings.jpg',
                                            label: 'Chicken Wings',
                                            onTap: () {
                                              prediction = 'Chicken Wings';
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NewBlankPage(
                                                        prediction: prediction),
                                              ));
                                            },
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomBar(
                onHomePressed: () {
                  // Handle home button press
                },
                onSearchPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipePage(),
                    ),
                  );
                },
                onProfilePressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        displayName: user?.displayName ?? 'Guest',
                        email: user?.email ?? '',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

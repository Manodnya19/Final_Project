import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:food_app/pages/search_recipe.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  String _searchText = '';
  List<Map<String, dynamic>> _recipes = [];
  bool _isLoading = false; // Track loading state

  Future<void> _fetchRecipes(String query) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    String url = "https://tasty.p.rapidapi.com/recipes/list";

    Map<String, String> queryParameters = {
      "from": "0",
      "size": "20",
      "q": query,
    };

    Map<String, String> headers = {
      'X-RapidAPI-Key': '98a7b86f4fmshbda6505ec474378p180a52jsn5a24106793f0',
      'X-RapidAPI-Host': 'tasty.p.rapidapi.com'
    };

    Uri uri = Uri.parse(url).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          _recipes = (jsonDecode(response.body)['results'] as List)
              .cast<Map<String, dynamic>>();
          _isLoading = false; // Stop loading
        });
      } else {
        print('Failed to fetch recipes. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Stop loading in case of failure
        });
      }
    } catch (error) {
      print('An error occurred: $error');
      setState(() {
        _isLoading = false; // Stop loading in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipes',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 28, 28, 28),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: null, // No onPressed for search icon
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search your favourite recipes',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Fetch recipes when arrow is tapped
                      _fetchRecipes(_searchText);
                    },
                  ),
                ],
              ),
            ),
          ),
          // Display progress indicator if loading, otherwise show recipes
          _isLoading
              ? Image.network(
                  'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcHdvbmdzY2NvdW02emV5MGhkMWp3ZTY0aDU4OWQzZ3YydTlkZW1oZyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7bu8sRnYpTOG1p8k/giphy.gif',
                  width: 200.0,
                  height: 200.0,
                ) // Show loading indicator
              : Expanded(
                  child: ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Handle the tap on a recipe
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchRecipe(
                                  recipeId: _recipes[index]['id'].toString()),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(_recipes[index]['name']),
                          // Add more details to display if needed
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

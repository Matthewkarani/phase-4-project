import 'dart:convert'; // For encoding JSON data
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the HTTP package
import 'package:recipe_recommendation_front_end/pages/recipe_pages/recipe_list_page.dart';

class GetRecipesPage extends StatefulWidget {
  @override
  _GetRecipesPageState createState() => _GetRecipesPageState();
}

class _GetRecipesPageState extends State<GetRecipesPage> {
  final TextEditingController _ingredientsController = TextEditingController();

  // Function to call the API and get recipes
  Future<List<Map<String, dynamic>>> _fetchRecipes(String ingredients) async {
    final url = Uri.parse('http://127.0.0.1:5000/recommend'); // Replace with your API URL
    try {
      // Make a POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ingredients': ingredients}), // Send ingredients as JSON
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> data = jsonDecode(response.body);

        // Convert the dynamic list into a list of maps for recipes
        List<Map<String, dynamic>> recipes = List<Map<String, dynamic>>.from(data);

        return recipes;
      } else {
        // Handle error response
        print('Failed to load recipes: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle network errors
      print('Error occurred: $error');
      return [];
    }
  }

  // Function to handle the search action based on input
  void _searchRecipes() async {
    String ingredients = _ingredientsController.text;

    if (ingredients.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Searching for recipes with: $ingredients')),
      );

      // Fetch recipes from the API
      List<Map<String, dynamic>> recipes = await _fetchRecipes(ingredients);

      if (recipes.isNotEmpty) {
        // Navigate to RecipeListPage with ingredients and fetched recipes
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeListPage(
              ingredients: ingredients,
              recipes: recipes,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No recipes found for the given ingredients')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ingredients')),
      );
    }
  }

  @override
  void dispose() {
    _ingredientsController.dispose(); // Dispose of the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/addIngredientsPage.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: screenSize.width * 0.05,
            bottom: screenSize.height * 0.15,
            width: screenSize.width * 0.4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get ready to excite your taste buds!',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _ingredientsController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Please enter your ingredients here',
                        hintStyle: TextStyle(color: Color(0xFFFFD700)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: _searchRecipes,
                          color: const Color(0xFF00c4cc),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide.none,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: const Text(
                            'Search',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.05,
            left: screenSize.width * 0.05,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
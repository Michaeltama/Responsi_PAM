import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meal_detail_screen.dart';

class MealListScreen extends StatelessWidget {
  final String category;

  const MealListScreen({Key? key, required this.category}) : super(key: key);

  Future<List<dynamic>> fetchMeals() async {
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?c=$category"));
    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'];
    } else {
      throw Exception("Failed to load meals");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category Meals')),
      body: FutureBuilder(
        future: fetchMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final meals = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return ListTile(
                  leading: Image.network(meal['strMealThumb']),
                  title: Text(meal['strMeal']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(
                          mealId: meal['idMeal'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

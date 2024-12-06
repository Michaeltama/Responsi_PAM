import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'meal_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List categories = [];
  String username = '';

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php"));
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body)['categories'];
      });
    }
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome, $username')),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  leading: Image.network(category['strCategoryThumb']),
                  title: Text(category['strCategory']),
                  subtitle: Text(category['strCategoryDescription']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealListScreen(
                          category: category['strCategory'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class MealDetailScreen extends StatelessWidget {
  final String mealId;

  const MealDetailScreen({Key? key, required this.mealId}) : super(key: key);

  Future<Map<String, dynamic>> fetchMealDetail() async {
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId"));
    if (response.statusCode == 200) {
      return (json.decode(response.body)['meals'][0]);
    } else {
      throw Exception("Failed to load meal detail");
    }
  }

  // Fungsi untuk meluncurkan URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Detail')),
      body: FutureBuilder(
        future: fetchMealDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final meal = snapshot.data as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar makanan dengan border
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        meal['strMealThumb'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250,
                      ),
                    ),
                  ),

                  // Nama makanan dengan border
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        meal['strMeal'],
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Instruksi memasak dengan border
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(meal['strInstructions']),
                    ),
                  ),

                  // Tombol untuk melihat video tutorial dengan border
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final url = meal['strYoutube'];
                        if (url != null) {
                          _launchURL(url);  // Meluncurkan URL tutorial
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey, width: 2),
                      ),
                      child: const Text('Watch Tutorial'),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/university_item.dart';
import 'package:account/provider/university_provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final scoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, 
        title: const Text('เพิ่มมหาวิทยาลัย'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextFormField(
                  controller: nameController,
                  label: 'ชื่อมหาวิทยาลัย',
                  prefixIcon: Icons.school,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อมหาวิทยาลัย';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextFormField(
                  controller: countryController,
                  label: 'ประเทศ',
                  prefixIcon: Icons.location_on,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อประเทศ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextFormField(
                  controller: scoreController,
                  label: 'คะแนน',
                  prefixIcon: Icons.star,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกคะแนน';
                    }
                    if (double.tryParse(value) == null) {
                      return 'กรุณากรอกคะแนนเป็นตัวเลข';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var provider = Provider.of<UniversityProvider>(context, listen: false);

                      double score = double.parse(scoreController.text);
                      
                      // Create a new university item
                      UniversityItem newUniversity = UniversityItem(
                        name: nameController.text,
                        rank: 0,  // Initially set to 0, we'll update it later
                        country: countryController.text,
                        score: score,
                      );

                      // Add the new university to the provider
                      provider.addUniversity(newUniversity);

                      // Get all universities and sort them by score in descending order
                      List<UniversityItem> allUniversities = provider.universities;
                      allUniversities.sort((a, b) => b.score.compareTo(a.score));

                      // Update the rank for each university based on the sorted list
                      for (int i = 0; i < allUniversities.length; i++) {
                        allUniversities[i].rank = i + 1; // Rank starts from 1
                      }

                      // Update the provider with the new ranking
                      provider.updateUniversities(allUniversities);

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black45,
                  ),
                  child: const Text(
                    'เพิ่มมหาวิทยาลัย',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16, color: Colors.blueAccent),
        prefixIcon: Icon(prefixIcon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.blue[50],
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

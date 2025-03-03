import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/university_item.dart';
import 'package:account/provider/university_provider.dart';

class EditScreen extends StatefulWidget {
  final UniversityItem university;

  const EditScreen({super.key, required this.university});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController rankController;
  late TextEditingController countryController;
  late TextEditingController scoreController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.university.name);
    rankController = TextEditingController(text: widget.university.rank.toString());
    countryController = TextEditingController(text: widget.university.country);
    scoreController = TextEditingController(text: widget.university.score.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('แก้ไขมหาวิทยาลัย'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                Text(
                  'กรุณากรอกข้อมูลมหาวิทยาลัยใหม่',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 24),

                // Name Input
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

                // Rank Input
                _buildTextFormField(
                  controller: rankController,
                  label: 'อันดับ',
                  prefixIcon: Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกอันดับ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Country Input
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

                // Score Input
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

                // Save Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 12,
                    shadowColor: Colors.black45,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var provider = Provider.of<UniversityProvider>(context, listen: false);
                      UniversityItem updatedUniversity = UniversityItem(
                        keyID: widget.university.keyID,
                        name: nameController.text,
                        rank: int.parse(rankController.text),
                        country: countryController.text,
                        score: double.parse(scoreController.text),
                      );

                      provider.updateUniversity(updatedUniversity);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'บันทึกการแก้ไข',
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

  // Reusable TextFormField method with modern design
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
        fillColor: Colors.blue[50], // Soft background color for input fields
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

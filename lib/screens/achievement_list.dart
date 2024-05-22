import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:achievement_app/models/achievement.dart';
import 'achievement_chart.dart';

class AchievementList extends StatefulWidget {
  @override
  _AchievementListState createState() => _AchievementListState();
}

class _AchievementListState extends State<AchievementList> {
  Box<Achievement> achievementBox = Hive.box('achievements');

  List<String> categories = [
    "Pendidikan",
    "Karier",
    "Kesehatan dan Kebugaran",
    "Keuangan",
    "Hubungan dan Keluarga",
    "Kontribusi Sosial",
    "Kreativitas",
    "Pengembangan Pribadi"
  ];
  // Daftar kategori yang tersedia
  String selectedCategory = "Pendidikan"; // Kategori default

  void _addAchievement(Achievement achievement) {
    achievementBox.add(achievement);
  }

  void _deleteAchievement(int index) {
    achievementBox.deleteAt(index);
  }

  void _updateAchievement(int index, Achievement achievement) {
    achievementBox.putAt(index, achievement);
  }

  void _showAchievementDialog({int? index, Achievement? achievement}) {
    TextEditingController titleController =
        TextEditingController(text: achievement?.title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: achievement?.description ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(index == null ? 'Tambah Pencapaian' : 'Update Pencapaian'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Batal',
                style: TextStyle(
                    color: Colors.red), // Warna teks merah untuk tombol 'Batal'
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                index == null ? 'Tambah' : 'Update',
                style: TextStyle(
                    color: Colors
                        .pinkAccent), // Warna teks biru untuk tombol 'Tambah' atau 'Update'
              ),
              onPressed: () {
                if (index == null) {
                  _addAchievement(Achievement(
                    title: titleController.text,
                    description: descriptionController.text,
                    category: selectedCategory,
                  ));
                } else {
                  _updateAchievement(
                    index,
                    Achievement(
                      title: titleController.text,
                      description: descriptionController.text,
                      category: selectedCategory,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Growth'),
        actions: [
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementChart()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: achievementBox.listenable(),
        builder: (context, Box<Achievement> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('Tidak Ada Pencapaian.'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Achievement achievement = box.getAt(index)!;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(
                      achievement.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Text(achievement.description),
                        SizedBox(height: 4.0),
                        Text(
                          'Kategori: ${achievement.category}',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () {
                            _showAchievementDialog(
                                index: index, achievement: achievement);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.pink),
                          onPressed: () {
                            _deleteAchievement(index);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
          ;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAchievementDialog();
        },
      ),
    );
  }
}

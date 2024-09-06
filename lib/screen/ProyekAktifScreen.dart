import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../utils/Constant.dart';
import 'DetailProyekScreen.dart';

class ProyekAktifScreen extends StatefulWidget {
  @override
  ProyekAktifState createState() => ProyekAktifState();
}

class ProyekAktifState extends State<ProyekAktifScreen> {
  late Future<List<int>> activeProjects;

  @override
  void initState() {
    super.initState();
    init();
    activeProjects = fetchActiveProjects();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  Future<List<int>> fetchActiveProjects() async {
    final response = await http.get(Uri.parse('${baseUrl}api/proyek-aktif'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map<int>((json) => json['id_proyek'] as int).toList();
    } else {
      throw Exception('Failed to load active projects');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Proyek Aktif Saat Ini', style: boldTextStyle(size: 18)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
              color: appStore.isDarkModeOn ? white : black),
          iconSize: 18,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),

      body: FutureBuilder<List<int>>(
        future: activeProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada proyek aktif yang tersedia'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                int projectId = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProyek(
                          projectId: projectId,
                        ),
                      ),
                    );
                  },
                  child: ProjectCard(
                    projectId: projectId,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

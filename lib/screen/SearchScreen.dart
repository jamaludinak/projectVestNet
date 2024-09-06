import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/Proyek/ProyekModel.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'DetailProyekScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<ProyekModel> allProjects = [];
  List<ProyekModel> filteredProjects = [];
  String selectedKabupaten = '';
  bool isLoading = false; // Untuk menampilkan indikator loading

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    setState(() {
      isLoading = true; // Mulai loading saat mengambil data
    });
    try {
      final response = await http.get(Uri.parse('${baseUrl}api/detailProyekAll'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          allProjects = jsonResponse.map((data) => ProyekModel.fromJson(data)).toList();
          filteredProjects = allProjects; // Menampilkan semua proyek pada awal
          isLoading = false; // Selesai loading
        });
      } else {
        print('Failed to load projects');
        setState(() {
          isLoading = false; // Gagal memuat data, berhenti loading
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Error, berhenti loading
      });
    }
  }

  void searchProjects(String query) {
    if (selectedKabupaten.isEmpty) {  // Hanya izinkan pencarian jika tidak ada kabupaten yang dipilih
      setState(() {
        if (query.isEmpty) {
          filteredProjects = allProjects; // Jika pencarian kosong dan tidak ada filter kabupaten
        } else {
          filteredProjects = allProjects.where((project) {
            final desaName = project.desa?.toLowerCase() ?? '';
            final input = query.toLowerCase();

            return desaName.contains(input);
          }).toList();
        }
      });
    }
  }

  void filterByKabupaten(String kabupaten) async {
    setState(() {
      isLoading = true;  // Mulai loading saat filter diterapkan
    });

    await Future.delayed(Duration(milliseconds: 500));  // Simulasi proses loading

    setState(() {
      selectedKabupaten = kabupaten;

      if (kabupaten.isEmpty && searchController.text.isEmpty) {
        filteredProjects = allProjects; // Reset jika tidak ada kabupaten dan pencarian
      } else {
        filteredProjects = allProjects.where((project) {
          final desaName = project.desa?.toLowerCase() ?? '';

          return (kabupaten.isEmpty || project.kabupaten == kabupaten);
        }).toList();
      }
      isLoading = false;  // Selesai loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Pencarian",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: context.cardColor,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color(0x00000000), width: 1),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Menampilkan loading jika isLoading true
          : SingleChildScrollView(
              padding: EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: searchProjects,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      enabled: selectedKabupaten.isEmpty, // Nonaktifkan TextField jika filter kabupaten aktif
                      style: primaryTextStyle(size: 16),
                      decoration: CustomInputDecoration.getDecoration(
                              hintText: selectedKabupaten.isNotEmpty
                                  ? "Cari Proyek Investasi"  // Berikan petunjuk jika tidak bisa di search
                                  : "Cari Proyek Investasi")
                          .copyWith(
                        prefixIcon: Icon(Icons.search_sharp),
                        filled: true,
                        fillColor: selectedKabupaten.isNotEmpty
                            ? Colors.grey.shade300  // Ubah warna jika TextField tidak aktif
                            : Color(0xFFF2F2F2),
                      ),
                    ),
                  ),
                  8.height,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: ['Banyumas', 'Purbalingga', 'Cilacap'].map((kabupaten) {
                        bool isActive = selectedKabupaten == kabupaten;
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: MaterialButton(
                            onPressed: () {
                              filterByKabupaten(isActive ? '' : kabupaten);
                            },
                            color: isActive ? PrimaryColor : Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                color: isActive ? Colors.transparent : Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              kabupaten,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isActive ? Colors.white : Colors.black,
                              ),
                            ),
                            height: 30,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  8.height,
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      "Semua Proyek",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  8.height,
                  Container(
                    child: filteredProjects.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredProjects.length,
                            itemBuilder: (context, index) {
                              var project = filteredProjects[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailProyek(
                                        projectId: project.idProyek,
                                      ),
                                    ),
                                  );
                                },
                                child: ProjectCard(
                                  projectId: project.idProyek,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text("Tidak ada proyek yang ditemukan."),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

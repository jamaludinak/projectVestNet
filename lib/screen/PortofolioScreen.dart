import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../component/portofolio/CardInvestasi.dart';
import '../utils/Constant.dart';
import 'DetailProyekInvestScreen.dart';
import 'package:http/http.dart' as http;

class PortofolioScreen extends StatefulWidget {
  @override
  PortofolioScreenState createState() => PortofolioScreenState();
}

class PortofolioScreenState extends State<PortofolioScreen> {
  List<int> investedProjectIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
    await fetchUserInvestedProjects();
  }

  Future<void> fetchUserInvestedProjects() async {
    try {
      String? token =
          await getToken(); // Fetch the token from secure storage or other methods
      final response = await http.get(
        Uri.parse('${baseUrl}api/user-invested-projects'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          investedProjectIds =
              List<int>.from(data['projects'].map((p) => p['id_proyek']));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load invested projects');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> getToken() async {
    // Replace this with your method to retrieve the token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Portofolio", style: boldTextStyle(size: 18)),
        centerTitle: false,
        backgroundColor: context.cardColor,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CardInvestasi(),
                  24.height,
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Daftar Proyek Yang Didukung",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: investedProjectIds.length,
                      itemBuilder: (context, index) {
                        final projectId = investedProjectIds[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailProyekInvest(
                                  projectId: '$projectId',
                                ),
                              ),
                            );
                          },
                          child: ProjectCardInvest(projectId: projectId),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

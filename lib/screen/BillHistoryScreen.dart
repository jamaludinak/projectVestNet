import 'package:flutter/material.dart';

class BillHistoryScreen extends StatefulWidget {
  @override
  _BillHistoryScreenState createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riwayat Tagihan Internet",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Tab-like buttons for "LUNAS" and "BELUM LUNAS"
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Tengah di row
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    decoration: BoxDecoration(
                      color: selectedIndex == 0 ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "LUNAS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedIndex == 0 ? Colors.white : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10), // Berikan jarak antar tab
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    decoration: BoxDecoration(
                      color: selectedIndex == 1 ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "BELUM LUNAS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedIndex == 1 ? Colors.white : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              
              ],
            ),
          ),
          // Body for the tab view
          Expanded(
            child: selectedIndex == 0 ? PaidBills() : UnpaidBills(),
          ),
        ],
      ),
    );
  }
}

class PaidBills extends StatelessWidget {
  final List<Map<String, String>> paidBills = [
    {"month": "Juli 2024", "amount": "Rp 166,500"},
    {"month": "Juni 2024", "amount": "Rp 166,500"},
    {"month": "Mei 2024", "amount": "Rp 166,500"},
    {"month": "April 2024", "amount": "Rp 166,500"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: paidBills.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                paidBills[index]["month"]!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    paidBills[index]["amount"]!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () {
                // Handle bill detail
              },
            ),
            Divider(height: 1, color: Colors.grey.shade300), // Garis tipis di bawah ListTile
          ],
        );
      },
    );
  }
}

class UnpaidBills extends StatelessWidget {
  final List<Map<String, String>> unpaidBills = [
    {"month": "Agustus 2024", "amount": "Rp 166,500"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: unpaidBills.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(
                unpaidBills[index]["month"]!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    unpaidBills[index]["amount"]!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
              onTap: () {
                // Handle bill detail
              },
            ),
            Divider(height: 1, color: Colors.grey.shade300), // Garis tipis di bawah ListTile
          ],
        );
      },
    );
  }
}

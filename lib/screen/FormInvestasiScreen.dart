import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'DashBoardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FormInvestasi extends StatefulWidget {
  final int projectId;
  final String desaName;

  FormInvestasi({required this.projectId, required this.desaName});

  @override
  FormInvestasiState createState() => FormInvestasiState();
}

class FormInvestasiState extends State<FormInvestasi> {
  final _formKey = GlobalKey<FormState>();
  final currencyFormatter =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  int? _selectedAmount;
  bool agreeToTerms = false;

  final List<int> _investmentOptions = [
    1000000,
    2000000,
    5000000,
    10000000,
    15000000,
    20000000
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        agreeToTerms &&
        _selectedAmount != null) {
      try {
        final token = await getToken();

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Token tidak ditemukan, silakan login kembali')),
          );
          return;
        }

        // Call the API to invest in the project
        final response = await http.post(
          Uri.parse('${baseUrl}api/investInProject'),
          body: {
            'id_proyek': widget.projectId.toString(),
            'total_investasi': _selectedAmount.toString(),
          },
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  'Data berhasil dikirim',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        DashBoardScreen().launch(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: PrimaryColor),
                      ),
                      child: Text(
                        'Lanjutkan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: PrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim data investasi')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } else {
      if (!agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus menyetujui syarat dan ketentuan')),
        );
      }
      if (_selectedAmount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus memilih jumlah investasi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Form Investasi ${widget.desaName}',
              style: boldTextStyle(size: 18)),
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
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metode Pembayaran',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(
                  'Transfer - Bank Mandiri\nNomer Rekening: 000000000\nAtas Nama: Toni Anwar',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 8),
                Text(
                  'Tunai\nSilakan hubungi kami untuk detail lebih lanjut.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 16),
                Text('Jumlah Investasi',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemCount: _investmentOptions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ChoiceChip(
                        label: Text(
                          currencyFormatter.format(_investmentOptions[index]),
                        ),
                        selected: _selectedAmount == _investmentOptions[index],
                        onSelected: (selected) {
                          setState(() {
                            _selectedAmount =
                                selected ? _investmentOptions[index] : null;
                          });
                        },
                        selectedColor: PrimaryColor,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: _selectedAmount == _investmentOptions[index]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                MaterialButton(
                  onPressed: () {
                    // Handle upload proof of transaction
                  },
                  color: PrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Upload Bukti Transaksi *jpg",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                  textColor: Color(0xffffffff),
                  height: 40,
                ),
                SizedBox(height: 16),
                Text(
                  termsAndConditions,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: agreeToTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          agreeToTerms = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Saya setuju dengan syarat dan ketentuan yang berlaku',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Center(
                  child: MaterialButton(
                    onPressed: _submitForm,
                    color: PrimaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Kirim",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal),
                    ),
                    textColor: Color(0xffffffff),
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width - 64,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

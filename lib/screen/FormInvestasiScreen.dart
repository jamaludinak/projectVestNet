import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'DashBoardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
  File? _selectedFile;

  final List<int> _investmentOptions = [
    2000000,
    3000000,
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

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'heic',
        'pdf'
      ], // tambahkan ekstensi yang sesuai
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada file yang dipilih')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        agreeToTerms &&
        _selectedAmount != null &&
        _selectedFile != null) {
      try {
        final token = await getToken();
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Token tidak ditemukan, silakan login kembali')),
          );
          return;
        }

        // Siapkan request multipart
        var request = http.MultipartRequest(
            'POST', Uri.parse('${baseUrl}api/investInProject'));
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['id_proyek'] = widget.projectId.toString();
        request.fields['total_investasi'] = _selectedAmount.toString();

        // Upload bukti transfer
        request.files.add(await http.MultipartFile.fromPath(
          'bukti_transfer',
          _selectedFile!.path,
        ));

        // Kirim request
        final response = await request.send();

        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content:
                    Text('Investasi berhasil!', textAlign: TextAlign.center),
                actions: [
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashBoardScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: PrimaryColor),
                      ),
                      child: Text(
                        'Lanjutkan',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: PrimaryColor),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim investasi.')),
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
      if (_selectedFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus mengunggah bukti transaksi')),
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
                // Metode Pembayaran
                Text('Metode Pembayaran',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transfer Bank Mandiri',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Nomer Rekening\t: 000000000\nAtas Nama\t: Toni Anwar',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tunai',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Silakan hubungi kami untuk detail lebih lanjut.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Jumlah Investasi
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
                // Tombol Unggah Bukti Transfer
                MaterialButton(
                  onPressed: _pickFile,
                  color: PrimaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        _selectedFile != null
                            ? 'Bukti dipilih: ${_selectedFile!.path.split('/').last}'
                            : "Upload Bukti Transaksi *jpg",
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
                SizedBox(height: 14),
                Text('Syarat dan Ketentuan',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '1. Pengguna harus berusia minimal 18 tahun. Aplikasi ini hanya dapat digunakan oleh individu yang sudah dewasa dan mampu membuat keputusan keuangan sendiri.\n'
                  '2. Semua investasi adalah final dan tidak ada jaminan keuntungan. Setelah melakukan investasi, dana tidak dapat ditarik kembali, dan VestNet tidak menjamin bahwa pengguna akan mendapatkan keuntungan dari investasi yang dilakukan.\n'
                  '3. Informasi pribadi pengguna dilindungi sesuai Kebijakan Privasi. VestNet berkomitmen untuk menjaga kerahasiaan dan keamanan data pribadi pengguna sesuai dengan kebijakan privasi yang berlaku.',
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

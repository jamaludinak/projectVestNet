import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../main.dart';
import '../utils/Colors.dart';
import 'DashBoardScreen.dart';

class FormulirTarikDana extends StatefulWidget {
  @override
  FormulirTarikDanaState createState() => FormulirTarikDanaState();
}

class FormulirTarikDanaState extends State<FormulirTarikDana> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahDanaController = TextEditingController();
  bool agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && agreeToTerms) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Data berhasil dikirim',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  DashBoardScreen().launch(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Lanjutkan',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      if (!agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus menyetujui syarat dan ketentuan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Formulir Pengajuan Tarik Dana', style: boldTextStyle(size: 18)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: appStore.isDarkModeOn ? white : black),
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
              Text('Jumlah dana yang ingin ditarik', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              TextFormField(
                controller: _jumlahDanaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan jumlah dana',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Belum diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 14),
              Text(
                'Syarat dan Ketentuan\n\n'
                '1. Pengguna harus berusia minimal 18 tahun. Aplikasi ini hanya dapat digunakan oleh individu yang sudah dewasa dan mampu membuat keputusan keuangan sendiri.\n\n'
                '2. Semua investasi adalah final dan tidak ada jaminan keuntungan. Setelah melakukan investasi, dana tidak dapat ditarik kembali, dan VestNet tidak menjamin bahwa pengguna akan mendapatkan keuntungan dari investasi yang dilakukan.\n\n'
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
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Kirim",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.normal,
                    ),
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
    );
  }
}

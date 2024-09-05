import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../main.dart';
import '../utils/Colors.dart';
import '../utils/Constant.dart';
import 'DashBoardScreen.dart';

class FormulirPengajuanInternet extends StatefulWidget {
  @override
  FormulirPengajuanInternetState createState() => FormulirPengajuanInternetState();
}

class FormulirPengajuanInternetState extends State<FormulirPengajuanInternet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaDesaController = TextEditingController();
  final TextEditingController _namaKepalaDesaController = TextEditingController();
  final TextEditingController _jumlahPendudukController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _nomorWAController = TextEditingController();

  bool agreeToTerms = false;

  String? selectedProvinsi;
  String? selectedKabupaten;
  String? selectedKecamatan;

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

  List<String> getKabupaten() {
    if (selectedProvinsi != null) {
      return kabupatenList[selectedProvinsi!] ?? [];
    }
    return [];
  }

  List<String> getKecamatan() {
    if (selectedKabupaten != null) {
      return kecamatanList[selectedKabupaten!] ?? [];
    }
    return [];
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && agreeToTerms) {
      try {
        String? token = await getToken();
        var response = await http.post(
          Uri.parse('${baseUrl}/api/submitPengajuanInternet'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          body: {
            'nama_desa': _namaDesaController.text,
            'kepala_desa': _namaKepalaDesaController.text,
            'kecamatan': selectedKecamatan ?? '', // tambahkan fallback jika null
            'kabupaten': selectedKabupaten ?? '', // tambahkan fallback jika null
            'provinsi': selectedProvinsi ?? '', // tambahkan fallback jika null
            'jumlah_penduduk': _jumlahPendudukController.text, // pastikan ambil teks
            'nomor_wa': _nomorWAController.text,
            'catatan': _catatanController.text.isNotEmpty ? _catatanController.text : 'Tidak ada', // fallback catatan
          },
        );

        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  'Pengajuan internet berhasil dikirim dan akan diproses.',
                  textAlign: TextAlign.center, // Membuat teks rata tengah
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      DashBoardScreen().launch(context); // Kembali ke halaman dashboard
                    },
                    child: Text(
                      'Lanjutkan',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim pengajuan internet.')),
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
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Formulir Pengajuan Internet', style: boldTextStyle(size: 18)),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Desa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                TextFormField(
                  controller: _namaDesaController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama desa',
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
                Text('Nama Kepala Desa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                TextFormField(
                  controller: _namaKepalaDesaController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama kepala desa',
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
                Text('Provinsi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedProvinsi,
                  decoration: InputDecoration(
                    hintText: 'Pilih Provinsi',
                    border: OutlineInputBorder(),
                  ),
                  items: provinsiList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedProvinsi = newValue;
                      selectedKabupaten = null;
                      selectedKecamatan = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Belum diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14),
                Text('Kabupaten', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedKabupaten,
                  decoration: InputDecoration(
                    hintText: 'Pilih Kabupaten',
                    border: OutlineInputBorder(),
                  ),
                  items: getKabupaten()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedKabupaten = newValue;
                      selectedKecamatan = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Belum diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 14),
                Text('Kecamatan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return getKecamatan().where((String option) {
                      return option.contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      selectedKecamatan = selection;
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Pilih atau ketik Kecamatan',
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(fontSize: 14),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Belum diisi';
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 14),
                Text('Jumlah Penduduk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                TextFormField(
                  controller: _jumlahPendudukController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Masukkan jumlah penduduk',
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Catatan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          TextFormField(
                            controller: _catatanController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Catatan',
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nomor WhatsApp', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          TextFormField(
                            controller: _nomorWAController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Masukkan nomor',
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Text(
                  'Syarat dan Ketentuan...',
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
                        'Saya setuju dengan Syarat dan Ketentuan',
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      "Kirim",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
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

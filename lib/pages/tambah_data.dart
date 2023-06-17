import 'package:crud_flutter/config/constanta.dart';
import 'package:crud_flutter/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  State<TambahData> createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future _simpan() async {
    try {
      final response = await http.post(Uri.parse("${url}user"), body: {
        "email": email.text,
        "name": name.text,
        "password": password.text
      });
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Data"),
      ),
      body: Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(7),
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle_rounded),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Nama tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: true,
                  controller: password,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _simpan().then((value) {
                        if (value) {
                          const snackBar = SnackBar(
                              content: Text('Data berhasil disimpan!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          const snackBar =
                              SnackBar(content: Text('Data gagal disimpan!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const HomePage())));
                    }
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.amber),
                  child: const Text("SIMPAN"),
                )
              ],
            ),
          )),
    );
  }
}

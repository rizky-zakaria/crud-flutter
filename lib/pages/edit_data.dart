import 'package:crud_flutter/config/constanta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditData extends StatefulWidget {
  final Map listData;
  const EditData({Key? key, required this.listData}) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  Future _ubahData() async {
    try {
      final response = await http
          .put(Uri.parse("${url}user/${widget.listData['id']}"), body: {
        "name": name.text,
        "email": email.text,
      });
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    name.text = widget.listData['name'];
    email.text = widget.listData['email'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Page"),
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
                      return "Nama haru diisi!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email haru diisi!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _ubahData().then((value) => {});
                      }
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.amber),
                    child: const Text("UBAH"))
              ],
            ),
          )),
    );
  }
}

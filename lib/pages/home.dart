import 'dart:convert';
import 'package:crud_flutter/config/constanta.dart';
import 'package:crud_flutter/pages/edit_data.dart';
import 'package:crud_flutter/pages/tambah_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listdata = [];
  bool _isloading = true;
  Future _getData() async {
    try {
      final response = await http.get(Uri.parse("${url}user"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data['data'];
          _isloading = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future _hapus(int id) async {
    try {
      final response = await http.delete(Uri.parse("${url}user/$id"));
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
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => EditData(
                                    listData: {
                                      "id": _listdata[index]['id'],
                                      "name": _listdata[index]['name'],
                                      "email": _listdata[index]['email'],
                                    },
                                  ))));
                    },
                    child: ListTile(
                      title: Text(_listdata[index]['name']),
                      subtitle: Text(_listdata[index]['email']),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: ((context) {
                                return AlertDialog(
                                  content: const Text("Yakin ingin menghapus?"),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Batal")),
                                    ElevatedButton(
                                        onPressed: () {
                                          _hapus(_listdata[index]['id'])
                                              .then((value) {
                                            if (value) {
                                              const snackBar = SnackBar(
                                                  content: Text(
                                                      'Data berhasil dihapus!'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              const snackBar = SnackBar(
                                                  content: Text(
                                                      'Data gagal dihapus!'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const HomePage())));
                                        },
                                        child: const Text("Hapus")),
                                  ],
                                );
                              }));
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
          child: const Text(
            '+',
            style: TextStyle(fontSize: 30),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const TambahData())));
          }),
    );
  }
}

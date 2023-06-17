import 'dart:convert';
import 'dart:math';

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
      final response = await http
          .get(Uri.parse('https://c0c6-36-75-191-72.ngrok-free.app/api/user'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
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
                  child: ListTile(
                    title: Text(_listdata[index]['name']),
                    subtitle: Text(_listdata[index]['email']),
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

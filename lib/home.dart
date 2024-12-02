import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:produk_form/details.dart';
import 'package:produk_form/models/mproduk.dart';
import 'package:produk_form/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:produk_form/tambah_produk.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<ProdukModel>> sw;

  void initState() {
    super.initState();
    sw = getSwList();
  }

  Future<List<ProdukModel>> getSwList() async {
    final response = await http.get(Uri.parse(Baseurl.data));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<ProdukModel> sw = items.map<ProdukModel>((json) {
      return ProdukModel.fromJson(json);
    }).toList();
    return sw;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' DAFTAR PRODUK '),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ProdukModel>>(
          future: sw,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.shopping_bag, color: Colors.teal[600]),
                    title: Text(
                      data.nama,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Rp. ${data.harga.toString()}", style: TextStyle(fontSize: 16)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(sw: data),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.teal[600],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahProduk()),
          );
        },
      ),
    );
  }
}

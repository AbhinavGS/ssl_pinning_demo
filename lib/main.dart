import "dart:io";

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  fetchData() async {
    final dio = Dio();
    ByteData bytes = await rootBundle.load('assets/certificates/reqres.pem');
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      SecurityContext sc = SecurityContext();
      sc.setTrustedCertificatesBytes(bytes.buffer.asUint8List());
      HttpClient httpClient = HttpClient(context: sc);
      return httpClient;
    };
    try {
      var response = await dio.get('https://reqres.in/api/users/1');
      print(response.data);
    } catch (error) {
      if (error is DioError) {
        print(error.toString());
      } else {
        print('Unexpected Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(child: Text("Press button to fetch data")),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        tooltip: 'Increment',
        child: const Icon(Icons.sync),
      ),
    );
  }
}

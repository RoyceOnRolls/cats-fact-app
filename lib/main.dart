// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Fact> fetchFact() async {
  final response = await http.get(Uri.parse('https://catfact.ninja/fact'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Fact.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load fact');
  }
}

class Fact {
  final int wordsNumber;
  final String fact;

  const Fact({
    required this.wordsNumber,
    required this.fact,
  });

  factory Fact.fromJson(Map<String, dynamic> json) {
    return Fact(
      wordsNumber: json['length'] as int,
      fact: json['fact'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Fact> futureFact;

  @override
  void initState() {
    super.initState();
    futureFact = fetchFact();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fetch Data Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Fetch Data Example'),
          ),
          body: Center(
            child: FutureBuilder<Fact>(
              future: futureFact,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.fact);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
          floatingActionButton: MaterialButton(
            onPressed: () {
              setState(() {
                futureFact = fetchFact();
              });
            },
            child:
                Text("Get new cat fact", style: TextStyle(color: Colors.white)),
            color: Colors.deepPurple,
            padding: EdgeInsets.all(24),
          ),
        ));
  }
}

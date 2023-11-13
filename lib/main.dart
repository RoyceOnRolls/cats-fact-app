// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

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
          // appBar: AppBar(
          //   title: const Text('Fetch Data Example'),
          // ),
          backgroundColor: Color.fromRGBO(206, 231, 248, 1),
          body: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
              child: Image(
                image: AssetImage('assets/cat.jpg'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Cat fact",
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontSize: 36,
                      )),
                    ),
                  ),
                  FutureBuilder<Fact>(
                    future: futureFact,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!.fact,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            fontSize: 18,
                          )),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          '${snapshot.error}',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            fontSize: 18,
                          )),
                        );
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ]),
          floatingActionButton: MaterialButton(
            onPressed: () {
              setState(() {
                futureFact = fetchFact();
              });
            },
            child: Text(
              "Get new cat fact 🐱",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 15, color: Colors.white)),
            ),
            color: Colors.blue.shade700,
            padding: EdgeInsets.all(24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ));
  }
}

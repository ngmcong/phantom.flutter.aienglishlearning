import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aienglishlearning/dataentities.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  late Future<List<AIEnlighQuestion>> aiEnlighQuestions;
  bool isAnswer = false;
  String statusString = "Loading";
  bool isInLoading = true;

  Future<List<AIEnlighQuestion>> generateObjects({
    String question =
        "i have an object have fields such as: question, option 1 to 4, correctOptionIndex. create for me a list which have greater 10 questions fill in blank for learning english with that object struct as json string.",
  }) async {
    setState(() {
      isInLoading = true;
      statusString = "Loading...";
    });
    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyAm-hDGemRSA0RA0ZfeV4n3_a5OSRLYxTw',
      ),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: "{\"contents\": [{\"parts\":[{\"text\": \"$question\"}]}]}",
    );
    if (response.statusCode == 200) {
      setState(() {
        statusString = 'Load successfully.';
      });
      var geminiResponse = GeminiResponse.fromJson(
        jsonDecode(
          response.body
              .replaceFirst('```json', '')
              .replaceAll('```', '')
              .replaceAll('\n', ''),
        ),
      );
      setState(() {
        statusString = 'Bulding UI.';
      });
      List listJson = jsonDecode(
        geminiResponse.candidates!.first.content!.parts!.first.text!,
      );
      var listObject =
          listJson.map((e) => AIEnlighQuestion.fromJson(e)).toList();
      setState(() {
        isInLoading = false;
      });
      return listObject;
    } else {
      setState(() {
        statusString = 'Failed to generate objects.';
      });
      throw Exception('Failed to generate objects.');
    }
  }

  @override
  void initState() {
    super.initState();
    aiEnlighQuestions = generateObjects();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder(
                    future: aiEnlighQuestions,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children:
                              snapshot.data!
                                  .map(
                                    (e) => Column(
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "${snapshot.data!.indexOf(e) + 1}. ${e.question!}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: isAnswer && e.isTrue(),
                                              child: Icon(
                                                Icons.indeterminate_check_box,
                                                size: 20.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text(e.option1!)),
                                            Checkbox(
                                              value: e.option1Checked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  e.resetChecked();
                                                  e.option1Checked = true;
                                                });
                                              },
                                              fillColor:
                                                  WidgetStateProperty.resolveWith((
                                                    states,
                                                  ) {
                                                    if (isAnswer &&
                                                        e.correctOptionIndex ==
                                                            0 &&
                                                        !states.contains(
                                                          WidgetState.selected,
                                                        )) {
                                                      return Colors.red;
                                                    }
                                                    return null;
                                                  }),
                                            ),
                                            Expanded(child: Text(e.option2!)),
                                            Checkbox(
                                              value: e.option2Checked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  e.resetChecked();
                                                  e.option2Checked = true;
                                                });
                                              },
                                              fillColor:
                                                  WidgetStateProperty.resolveWith((
                                                    states,
                                                  ) {
                                                    if (isAnswer &&
                                                        e.correctOptionIndex ==
                                                            1 &&
                                                        !states.contains(
                                                          WidgetState.selected,
                                                        )) {
                                                      return Colors.red;
                                                    }
                                                    return null;
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(child: Text(e.option3!)),
                                            Checkbox(
                                              value: e.option3Checked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  e.resetChecked();
                                                  e.option3Checked = true;
                                                });
                                              },
                                              fillColor:
                                                  WidgetStateProperty.resolveWith((
                                                    states,
                                                  ) {
                                                    if (isAnswer &&
                                                        e.correctOptionIndex ==
                                                            2 &&
                                                        !states.contains(
                                                          WidgetState.selected,
                                                        )) {
                                                      return Colors.red;
                                                    }
                                                    return null;
                                                  }),
                                            ),
                                            Expanded(child: Text(e.option4!)),
                                            Checkbox(
                                              value: e.option4Checked,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  e.resetChecked();
                                                  e.option4Checked = true;
                                                });
                                              },
                                              fillColor:
                                                  WidgetStateProperty.resolveWith((
                                                    states,
                                                  ) {
                                                    if (isAnswer &&
                                                        e.correctOptionIndex ==
                                                            3 &&
                                                        !states.contains(
                                                          WidgetState.selected,
                                                        )) {
                                                      return Colors.red;
                                                    }
                                                    return null;
                                                  }),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        );
                      } else {
                        return Text('Generate Objects');
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                visible: isInLoading,
                child: Row(
                  children: [
                    Text(statusString),
                  ]
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isAnswer = true;
                      });
                    },
                    child: Text('Check answers'),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isAnswer = false;
                        generateObjects(question: "make another");
                      });
                    },
                    child: Text('Try a another test'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

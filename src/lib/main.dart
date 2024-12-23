import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
  List<String> questionValues = [];
  String? deviceId;

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      return AndroidId().getId();
    }
    return null;
  }

  Future<List<AIEnlighQuestion>> generateObjects() async {
    try {
      setState(() {
        isInLoading = true;
        statusString = "Loading...";
      });
      String question =
          "I have an object have fields such as: question, option 1 to 4, correctOptionIndex. Create for me a list which have greater 10 questions fill in blank for learning english with that object struct as json string.";
      if (questionValues.isNotEmpty) {
        question +=
            " Remember that question must not in list [${questionValues.join(",")}].";
      }
      deviceId ??= await getDeviceId();
      final response = await http.post(
        Uri.parse(
          'https://www.vuonmamoi.somee.com/Admin/GeminiQuestion',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'DeviceID': '$deviceId',
        },
        body: jsonEncode(question),
      );
      if (response.statusCode == 200) {
        setState(() {
          statusString = 'Load successfully.';
        });
        var geminiResponse = GeminiResponse.fromJson(jsonDecode(response.body.replaceAll('\n', ''),));
        setState(() {
          statusString = 'Bulding UI.';
        });
        var jsonString =
            geminiResponse.candidates!.first.content!.parts!.first.text!;
        jsonString = jsonString.replaceFirst('```json', '');
        String jsonPattern = '```';
        if (jsonString.lastIndexOf(jsonPattern) > 0) {
          jsonString = jsonString.substring(
            0,
            jsonString.lastIndexOf(jsonPattern),
          );
        }
        List listJson = jsonDecode(jsonString);
        var listObject =
            listJson.map((e) => AIEnlighQuestion.fromJson(e)).toList();
        questionValues.addAll(listObject.map((e) => "'${e.question!}'"));
        setState(() {
          isInLoading = false;
        });
        return listObject;
      } else {
        throw Exception('Failed to generate objects.');
      }
    } catch (ex) {
      setState(() {
        statusString = 'Failed to generate objects.';
      });
      rethrow;
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
              Visibility(
                visible: isInLoading == false,
                child: Expanded(
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
              ),
              Visibility(
                visible: isInLoading,
                child: Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text(statusString),
                  ],
                )),
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
                        aiEnlighQuestions = generateObjects();
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

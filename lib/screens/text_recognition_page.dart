import 'package:flutter/material.dart';
import 'package:learning_input_image/learning_input_image.dart';
import 'package:learning_text_recognition/learning_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:text_recognition/provider.dart/text_recognition_provider.dart';

class TextRecognitionPage extends StatefulWidget {
  @override
  _TextRecognitionPageState createState() => _TextRecognitionPageState();
}

class _TextRecognitionPageState extends State<TextRecognitionPage> {
  TextRecognition? _textRecognition = TextRecognition();
  String mytext = "";
  @override
  void dispose() {
    _textRecognition?.dispose();
    super.dispose();
  }

  Future<void> _startRecognition(InputImage image) async {
    TextRecognitionState state = Provider.of(context, listen: false);

    if (state.isNotProcessing) {
      state.startProcessing();
      state.image = image;
      state.data = await _textRecognition?.process(image);
      state.stopProcessing();
    }
  }

  back() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: InputCameraView(
                mode: InputCameraMode.gallery,
                title: 'Text Recognition',
                onImage: _startRecognition,
                // overlay: Consumer<TextRecognitionState>(
                //   builder: (_, state, __) {
                //     if (state.isNotEmpty) {
                //       mytext = state.text;
                //       print(mytext);
                //       return Center(
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 10, horizontal: 16),
                //           decoration: BoxDecoration(
                //             color: Colors.white.withOpacity(0.8),
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(4.0)),
                //           ),
                //           child: Text(
                //             state.text,
                //             style: const TextStyle(
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ),
                //       );
                //     }

                //     return Container();
                //   },
                // ),
              ),
            ),
            Consumer<TextRecognitionState>(
              builder: (_, state, __) {
                if (state.isNotEmpty) {
                  back();
                  return Container();
                  // Center(
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 10, horizontal: 16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.8),
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(4.0)),
                  //     ),
                  //     child: Text(
                  //       state.text,
                  //       style: const TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // );

                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:math';

import 'package:fitween/src/model/class/exercise.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart' as image_lib;

class Classifier {
  static String model = 'model/lite-model_movenet_singlepose_lightning_3.tflite';

  late Interpreter interpreter;
  late ImageProcessor imageProcessor;
  late TensorImage inputImage;
  late List<Object> inputs;

  Map<int, Object> outputs = {};
  TensorBuffer outputLocations = TensorBufferFloat([]);

  Stopwatch stopwatch = Stopwatch();
  int frameNo = 0;

  Classifier([Interpreter? interpret]) {
    loadModel(interpret);
  }

  void runModel() async {
    Map<int, Object> outputs = {0: outputLocations.buffer};
    interpreter.runForMultipleInputs(inputs, outputs);
  }

  Future loadModel([Interpreter? interpret]) async {
    interpreter = interpret ?? await Interpreter.fromAsset(
      model, options: InterpreterOptions()..threads = 4,
    );
    outputLocations = TensorBufferFloat([1, 1, 17, 3]);
  }

  TensorImage getProcessedImage() {
    int padSize = max(inputImage.height, inputImage.width);
    imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(padSize, padSize))
        .add(ResizeOp(192, 192, ResizeMethod.BILINEAR))
        .build();

    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  static int yuv2rgb(int y, int u, int v) {
    int r = (y + v * 1436 / 1024 - 179).round();
    int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    int b = (y + u * 1814 / 1024 - 227).round();

    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
    ((b << 16) & 0xff0000) |
    ((g << 8) & 0xff00) |
    (r & 0xff);
  }

  image_lib.Image convertCameraImage(IsolateData data) {
    final cameraImage = data.cameraImage;
    int width = cameraImage.width;
    int height = cameraImage.height;
    bool isPortrait = data.orientation == Orientation.portrait;

    image_lib.Image image = image_lib.Image(width, height);

    // if (Platform.isAndroid) {
    //   image = image_lib.Image(height, width);
    // }
    // else if (Platform.isIOS) {
    //   image = image_lib.Image(width, height);
    // }

    if (Platform.isAndroid) {
      final int uvRowStride = cameraImage.planes[1].bytesPerRow;
      final int? uvPixelStride = cameraImage.planes[1].bytesPerPixel;

      for (int w = 0; w < width; w++) {
        for (int h = 0; h < height; h++) {
          final int uvIndex = uvPixelStride! * (w / 2).floor() + uvRowStride * (h / 2).floor();
          final int index = h * width + w;

          final y = cameraImage.planes[0].bytes[index];
          final u = cameraImage.planes[1].bytes[uvIndex];
          final v = cameraImage.planes[2].bytes[uvIndex];

          image.data[index] = yuv2rgb(y, u, v);
        }
      }

      image = image_lib.copyRotate(image, 90.0);
      print([width, height]);
      print([image.width, image.height]);
      print([cameraImage.width, cameraImage.height]);
      print('');

      // image = image_lib.copyRotate(image, isPortrait ? 90.0 : 180.0);
      // image = image_lib.flipHorizontal(image);
    }

    else if (Platform.isIOS) {
      var datum = cameraImage.planes.first.bytes.buffer.asUint32List();
      for (int i = 0; i < width * height; i++) { image.data[i] = datum[i]; }
    }

    return image;
  }

  void performOperations(IsolateData data) async {
    stopwatch.start();

    image_lib.Image convertedImage = convertCameraImage(data);

    inputImage = TensorImage(TfLiteType.float32);
    inputImage.loadImage(convertedImage);
    inputImage = getProcessedImage();

    inputs = [inputImage.buffer];

    stopwatch.stop();
    frameNo++;

    stopwatch.reset();
  }

  List parseLandmarkData(Orientation orientation) {
    List<double> data = outputLocations.getDoubleList();
    List result = [];
    late int x, y;
    late double c;

    late double first, second;

    first = CameraCont.presetSize.height;
    second = CameraCont.presetSize.width;

    // switch (defaultTargetPlatform) {
    //   case TargetPlatform.android:
    //     first = CameraCont.presetSize.height;
    //     second = CameraCont.presetSize.width;
    //     break;
    //
    //   case TargetPlatform.iOS:
    //     first = CameraCont.presetSize.width;
    //     second = CameraCont.presetSize.height;
    //
    //     if (orientation == Orientation.landscape) {
    //       first = CameraCont.presetSize.height;
    //       second = CameraCont.presetSize.width;
    //     }
    //     break;
    //
    //   default: break;
    // }

    for (var i = 0; i < 51; i += 3) {
      y = (data[0 + i] * first).toInt();
      x = (data[1 + i] * second).toInt();
      c = (data[2 + i]);
      result.add([x, y, c]);
    }

    return result;
  }
}
import 'package:flutter/material.dart';
import 'package:histomictk/models/drawing_mode.dart';
import 'package:histomictk/models/sketch.dart';
import 'package:histomictk/pages/anno_menu.dart';

import '../../models/annotation.dart';
import '../../models/elements.dart';

class AppData with ChangeNotifier{
  String userid = '6669af318b3264ae3120f019';
  String folderid = '';
  String slideid = '58b480bb92ca9a000b08c89f';
  String slidename = '';
  String annotationname = 'Easy1.png';
  String annotationdate = '';
  String annotationdesc = '';


  bool drawing = false;
  bool show = true;
  bool labels = false;
  bool annotating = false;
  List<Annotation> annotation = [];
  List<Elements> elements = [];

  var annotop = ValueNotifier<double>(90);
  var annofop = ValueNotifier<double>(100);
  var parentid = ValueNotifier<String>(randomHexString(25));
  var selectedColor = ValueNotifier<Color>(Colors.red);
  var strokeSize = ValueNotifier<double>(3);
  var eraserSize = ValueNotifier<double>(30);
  var drawingMode = ValueNotifier(DrawingMode.pencil);
  var filled = ValueNotifier<bool>(false);
  var canvasGlobalKey = GlobalKey();
  ValueNotifier<Sketch?> currentSketch = ValueNotifier(null);
  ValueNotifier<List<Sketch>> allSketches = ValueNotifier([]);

  notifyChange(){
    notifyListeners();
  }
}
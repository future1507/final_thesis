import 'dart:io';
import 'package:flutter/material.dart';
import 'package:histomictk/drawing_canvas/drawing_canvas.dart';
import 'package:histomictk/models/annotation.dart';
import 'package:histomictk/models/drawing_mode.dart';
import 'package:histomictk/models/sketch.dart';
import 'package:histomictk/pages/anno_menu.dart';
import 'package:histomictk/service/provider/appdata.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:http/http.dart';

class Annotate extends StatefulWidget {
  const Annotate({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AnnotateState();
  }
}

class _AnnotateState extends State<Annotate> {
  final xzoom = ValueNotifier(1.5);
  final orginalxzoom = ValueNotifier(0.0);
  PhotoViewController? controller;
  ValueNotifier exapandsize1 = ValueNotifier<double>(180.0);
  int i = 0;
  double x = 0;
  double y = 0;
  Offset xy = Offset.zero;
  bool check = false;

  //List<Annotation> annotation = [];
  var showannoid = "";

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController()..outputStateStream.listen(listener);
    context.read<AppData>().drawing = false;

    context.read<AppData>().annotop = ValueNotifier<double>(90);
    context.read<AppData>().annofop = ValueNotifier<double>(100);
    context.read<AppData>().selectedColor = ValueNotifier<Color>(Colors.red);
    context.read<AppData>().strokeSize = ValueNotifier<double>(3);
    context.read<AppData>().eraserSize = ValueNotifier<double>(30);
    context.read<AppData>().drawingMode = ValueNotifier(DrawingMode.pencil);
    context.read<AppData>().filled = ValueNotifier<bool>(false);
    context.read<AppData>().canvasGlobalKey = GlobalKey();
    context.read<AppData>().currentSketch = ValueNotifier(null);
    context.read<AppData>().allSketches = ValueNotifier([]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setisshowZero(context.read<AppData>().slideid);
      context.read<AppData>().annotation =
          await loadAnnotation(context.read<AppData>().slideid);
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    if (i == 0) {
      orginalxzoom.value = value.scale!;
      setState(() {});
    }
    i++;
    xzoom.value = value.scale!;
    // print(xzoom.value);
  }

  String getslidename() {
    var laststop = context.read<AppData>().slidename.lastIndexOf('.');
    String name = context.read<AppData>().slidename.substring(0, laststop);
    return name;
  }

  void _notingTodo(details) {}

  void _updateLocation(details) {
    check = false;
    int index = 0;
    //List<Offset> ssketch = [];
    List<List<double>> minxy = List.filled(
        context.read<AppData>().allSketches.value.length, [50000, 50000]);
    List<List<double>> maxxy =
        List.filled(context.read<AppData>().allSketches.value.length, [0, 0]);
    //print('(${details.localPosition.dx},${details.localPosition.dy})');
    setState(() {
      x = details.localPosition.dx;
      y = details.localPosition.dy;
      xy = Offset(x, y);
    });
    for (Sketch sketch in context.read<AppData>().allSketches.value) {
      //print(sketch.points.length);
      for (int i = 0; i < sketch.points.length; i++) {
        minxy[index] = [
          min(minxy[index][0], sketch.points[i].dx),
          min(minxy[index][1], sketch.points[i].dy),
        ];
        maxxy[index] = [
          max(maxxy[index][0], sketch.points[i].dx),
          max(maxxy[index][1], sketch.points[i].dy),
        ];
      }
      index++;
    }
    var n = 0;
    for (int i = 0; i < minxy.length; i++) {
      var minx = minxy[i][0];
      var miny = minxy[i][1];
      var maxx = maxxy[i][0];
      var maxy = maxxy[i][1];
      if (x >= minx && x <= maxx && y >= miny && y <= maxy) {
        check = true;
        n = i;
      }
    }
    if (check == true) {
      showannoid = context.read<AppData>().allSketches.value[n].id;
      var anno = context
          .read<AppData>()
          .annotation
          .firstWhere((a) => a.annoId == showannoid);
      var time =
          DateFormat.yMd().add_jms().format(anno.created);
      showtooltip(anno.annoName, time, anno.creatorId, anno.descs!);
    }
  }

  void showtooltip(String name, String time, String creatorid, String desc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(name),
            content: Text(
              " Created : $time\n"
              " CreatorID : $creatorid\n"
              " \n$desc\n",
              softWrap: true,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<AppData>().slidename,
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Stack(
        children: [
          PhotoView.customChild(
            disableGestures: context.watch<AppData>().drawing,
            maxScale: PhotoViewComputedScale.contained * 80,
            controller: controller,
            onScaleEnd: (context, details, controllerValue) {
              xzoom.value = controllerValue.scale!;
              context.read<AppData>().drawing = false;
              context.read<AppData>().notifyChange();
            },
            child: GestureDetector(
              onTapUp: context.watch<AppData>().labels == true
                  ? _updateLocation
                  : _notingTodo,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/img/Easy1.png'),
                  // context.watch<AppData>().slideid == "589e030a92ca9a00118a6166"
                  //     ? Image.asset('assets/img/${getslidename()}.png')
                  //     : Image.network(
                  //         'https://demo.kitware.com/histomicstk/api/v1/item/' +
                  //             context.read<AppData>().slideid +
                  //             '/tiles/region?regionHeight=720&units=base_pixels&width=1280&height=720&exact=false&encoding=JPEG&jpegQuality=95&jpegSubsampling=0'),
                  DrawingCanvas(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    scale: xzoom.value,
                    id: context.watch<AppData>().parentid,
                    annotop: context.watch<AppData>().annotop,
                    annofop: context.watch<AppData>().annofop,
                    selectedColor: context.watch<AppData>().selectedColor,
                    strokeSize: context.watch<AppData>().strokeSize,
                    eraserSize: context.watch<AppData>().eraserSize,
                    drawingMode: context.watch<AppData>().drawingMode,
                    currentSketch: context.watch<AppData>().currentSketch,
                    allSketches: context.watch<AppData>().allSketches,
                    canvasGlobalKey: context.watch<AppData>().canvasGlobalKey,
                    filled: context.watch<AppData>().filled,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 50.0,
            top: 50.0,
            child: ZoomMenu(xzoom, orginalxzoom, controller),
          ),
          Positioned(
            right: 50,
            top: 50 + 200,
            child: AnnotationMenu(
              annotop: context.watch<AppData>().annotop,
              annofop: context.watch<AppData>().annofop,
              annotation: context.watch<AppData>().annotation,
            ),
          ),
          Positioned(
            left: 50,
            top: 50,
            child: DrawingMenu(
              selectedColor: context.watch<AppData>().selectedColor,
              strokeSize: context.watch<AppData>().strokeSize,
              eraserSize: context.watch<AppData>().eraserSize,
              drawingMode: context.watch<AppData>().drawingMode,
              currentSketch: context.watch<AppData>().currentSketch,
              allSketches: context.watch<AppData>().allSketches,
              filled: context.watch<AppData>().filled,
            ),
          ),
          const Positioned(left: 50, top: 300, child: PanandLock())
        ],
      ),
    );
  }
}

Future<List<Annotation>> loadAnnotation(String id) async {
  var response = await get(Uri.parse('http://10.0.2.2:5000/annotation/' + id),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  print("Load Annotation : " + response.body);
  var anno = annotationFromJson(response.body);
  return anno;
}

void setisshowZero(String id) async {
  print('setzero');
  var result = await patch(Uri.parse('http://10.0.2.2:5000/setzero/' + id),
      headers: {'Content-Type': 'application/json'});
  print(result);
  print(result.statusCode.toString());
}

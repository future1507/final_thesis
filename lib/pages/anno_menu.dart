import 'dart:convert';
import 'package:histomictk/pages/annotate.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:histomictk/models/drawing_mode.dart';
import 'package:histomictk/models/sketch.dart';
import 'package:histomictk/service/provider/appdata.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:histomictk/global.dart' as globals;
import 'dart:math';
import '../models/annotation.dart';
import '../models/elements.dart';

class ZoomMenu extends HookWidget {
  final ValueNotifier<double> xzoom;
  final ValueNotifier<double> orginalxzoom;
  final PhotoViewController? controller;

  const ZoomMenu(
    this.xzoom,
    this.orginalxzoom,
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final exapandsize1 = useState<double>(180);
    final xzooms = useState<double>(xzoom.value);
    //final orginalxzooms = useState<double>(orginalxzoom.value);

    List<ZoomX> btnZoom = [
      ZoomX(xtext: 'Fit', xvalue: 0.4),
      ZoomX(xtext: '2.5', xvalue: 2.5),
      ZoomX(xtext: '5', xvalue: 5),
      ZoomX(xtext: '10', xvalue: 10),
      ZoomX(xtext: '20', xvalue: 20),
      ZoomX(xtext: '40', xvalue: 40),
      ZoomX(xtext: '80', xvalue: 80),
    ];
    return SizedBox(
      width: 250,
      height: exapandsize1.value + 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: ExpansionTile(
          leading: const Icon(
            Icons.zoom_in,
            color: Colors.white,
          ),
          title: const Text(
            'Zoom',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.greenAccent,
          iconColor: Colors.white,
          collapsedBackgroundColor: Colors.greenAccent,
          collapsedIconColor: Colors.white,
          expansionAnimationStyle: AnimationStyle.noAnimation,
          initiallyExpanded: true,
          onExpansionChanged: (value) {
            if (value == false) {
              exapandsize1.value = 58;
            } else {
              exapandsize1.value = 185.0;
            }
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                alignment: Alignment.center,
                color: Colors.black26,
                width: 250,
                height: 1,
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Slider(
                            value: xzooms.value,
                            min: orginalxzoom.value - 0.1,
                            max: 80,
                            divisions: 80 * 10,
                            label: xzoom.value.toStringAsFixed(1),
                            activeColor: Colors.blueGrey,
                            inactiveColor: Colors.white,
                            thumbColor: Colors.blueGrey,
                            onChanged: (double value) {
                              context.read<AppData>().drawing = false;
                              context.read<AppData>().notifyChange();
                              xzooms.value = value;
                              controller?.scale = xzooms.value;
                            },
                          ),
                        ),
                        Text(xzoom.value.toStringAsFixed(1)),
                      ],
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < btnZoom.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: FloatingActionButton(
                                heroTag: 'btn${btnZoom[i].xtext}',
                                foregroundColor:
                                    btnZoom[i].xvalue == xzoom.value
                                        ? Colors.white
                                        : Colors.black,
                                backgroundColor:
                                    btnZoom[i].xvalue == xzoom.value
                                        ? Colors.greenAccent
                                        : Colors.white,
                                onPressed: () {
                                  context.read<AppData>().drawing = false;
                                  btnZoom[0].xvalue = orginalxzoom.value;
                                  if (btnZoom[i].xtext == 'Fit') {
                                    context.read<AppData>().drawing = true;
                                    xzooms.value = orginalxzoom.value;
                                    controller?.scale = xzooms.value;
                                  } else {
                                    xzooms.value = btnZoom[i].xvalue;
                                    controller?.scale = xzooms.value;
                                  }
                                  context.read<AppData>().notifyChange();
                                },
                                child: Text(btnZoom[i].xtext),
                              ),
                            ),
                          )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black26,
                        width: 250,
                        height: 2,
                      ),
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text('Capture'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: FloatingActionButton(
                              heroTag: 'btncap1',
                              backgroundColor: Colors.white,
                              onPressed: () {},
                              child: const Icon(
                                Icons.fit_screen_sharp,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: FloatingActionButton(
                              heroTag: 'btncap2',
                              backgroundColor: Colors.white,
                              onPressed: () {},
                              child: const Icon(
                                Icons.crop_landscape_sharp,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AnnotationMenu extends HookWidget {
  final ValueNotifier<double> annotop;
  final ValueNotifier<double> annofop;
  final List<Annotation> annotation;

  const AnnotationMenu(
      {super.key,
      required this.annotop,
      required this.annofop,
      required this.annotation});

  @override
  Widget build(BuildContext context) {
    final exapandsize2 = useState<double>(180.0);
    //final annotops = useState<double>(annotop.value*10);
    //final annofop = useState<double>(100.0);
    //final isshow = useState<bool>(false);

    //final annoname = TextEditingController(text: 'Annotation '+formattedDate);
    final annoname = useState<TextEditingController>(TextEditingController());
    final annodesc = useState<TextEditingController>(TextEditingController());
    List<Sketch> sketch = [];

    //context.read<AppData>().anno.add(Annotations(name: '1', desc: '1', date: '12-12-2012'));
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd HH:mm").format(now);

    //List<Annotation> annotation = [];
    void annotationDialog() {
      annoname.value.text = 'Annotation $formattedDate';
      //annodesc.value.text = 'xxx';
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Creat annotation',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.greenAccent,
              content: SizedBox(
                height: 250,
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Colors.black12,
                    ),
                    const Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    TextField(
                      controller: annoname.value,
                      decoration: InputDecoration(
                        hintText: '   Enter a name',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: annodesc.value,
                      maxLines: 2,
                      //scrollPadding: EdgeInsets.only(bottom: 40),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 20),
                        hintText: '   Enter an optional description',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                  onPressed: () {
                    // if(annodesc.value.text == ''){
                    //   annodesc.value.text = 'No Desciption';
                    // }
                    context.read<AppData>().annotating = true;
                    context.read<AppData>().notifyChange();

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
    }

    void editannoDialog(String id, String name, String desc) {
      annoname.value.text = name;
      annodesc.value.text = desc;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Edit annotation',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.greenAccent,
              content: SizedBox(
                height: 250,
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Colors.black12,
                    ),
                    const Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    TextField(
                      controller: annoname.value,
                      decoration: InputDecoration(
                        hintText: '   Enter a name',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    TextField(
                      controller: annodesc.value,
                      maxLines: 2,
                      //scrollPadding: EdgeInsets.only(bottom: 40),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 20),
                        hintText: '   Enter an optional description',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey),
                  onPressed: () async {
                    var data = {
                      "anno_name": annoname.value.text,
                      "descs": annodesc.value.text,
                      "updated": now.toString(),
                      "update_id": "6669af318b3264ae3120f019",
                    };
                    context
                        .read<AppData>()
                        .annotation
                        .firstWhere((anno) => anno.annoId == id)
                        .descs = annodesc.value.text;
                    context
                        .read<AppData>()
                        .annotation
                        .firstWhere((anno) => anno.annoId == id)
                        .annoName = annoname.value.text;
                    updateAnnotation(id, data);
                    context.read<AppData>().annotation =
                        await loadAnnotation(context.read<AppData>().slideid);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
    }

    void deleteannoDialog(String id, String name) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Warning',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              backgroundColor: Colors.greenAccent,
              content: SizedBox(
                height: 100,
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      color: Colors.black12,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(
                        'Are you sure you want to delete ' + name + '?',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    deleteAnnotation(id);
                    context
                        .read<AppData>()
                        .allSketches
                        .value
                        .removeWhere((element) => element.id == id);
                    context.read<AppData>().annotation =
                        await loadAnnotation(context.read<AppData>().slideid);
                    context.read<AppData>().notifyChange();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          });
    }

    return SizedBox(
      width: 250,
      height: exapandsize2.value + 5000,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ExpansionTile(
            leading: const Icon(
              Icons.discount,
              color: Colors.white,
            ),
            title: const Text(
              'Annotations',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.greenAccent,
            iconColor: Colors.white,
            collapsedBackgroundColor: Colors.greenAccent,
            collapsedIconColor: Colors.white,
            expansionAnimationStyle: AnimationStyle.noAnimation,
            initiallyExpanded: true,
            onExpansionChanged: (value) {
              if (value == false) {
                exapandsize2.value = 50;
              } else {
                exapandsize2.value = 180.0;
              }
            },
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black26,
                  width: 250,
                  height: 1,
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: Tooltip(
                        message: 'Show all annotations',
                        child: FloatingActionButton(
                          heroTag: 'showanno',
                          backgroundColor: Colors.white,
                          onPressed: () {
                            context.read<AppData>().show = true;
                            context.read<AppData>().notifyChange();
                          },
                          child: const Icon(
                            Icons.visibility_outlined,
                            size: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: Tooltip(
                        message: 'Hide all annotations',
                        child: FloatingActionButton(
                          heroTag: 'hideanno',
                          backgroundColor: Colors.white,
                          onPressed: () {
                            context.read<AppData>().show = false;
                            context.read<AppData>().notifyChange();
                          },
                          child: const Icon(
                            Icons.visibility_off_outlined,
                            size: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Tooltip(
                      message: 'Annotations total opacity ${annotop.value} %',
                      child: Slider(
                        value: annotop.value,
                        min: 0.0,
                        max: 100.0,
                        divisions: 100,
                        label: annotop.value.round().toString(),
                        activeColor: Colors.blueGrey,
                        inactiveColor: Colors.white,
                        thumbColor: Colors.blueGrey,
                        onChanged: (double value) {
                          annotop.value = value;
                          context.read<AppData>().annotop.value = annotop.value;
                          context.read<AppData>().notifyChange();

                          context.read<AppData>().annofop.value = annotop.value;
                          context.read<AppData>().notifyChange();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Tooltip(
                      message: 'Annotations fill opacity ${annofop.value} %',
                      child: Slider(
                        value: annofop.value,
                        max: 100.0,
                        divisions: 100,
                        label: annofop.value.round().toString(),
                        activeColor: Colors.blueGrey,
                        inactiveColor: Colors.white,
                        thumbColor: Colors.blueGrey,
                        onChanged: (double value) {
                          annofop.value = value;
                          context.read<AppData>().annofop.value = annofop.value;
                          context.read<AppData>().notifyChange();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black26,
                  width: 250,
                  height: 2,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ExpansionTile(
                  leading: const Icon(
                    Icons.folder,
                    size: 18,
                    color: Colors.blueGrey,
                  ),
                  title: const Text(
                    'Other',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  children: [
                    annotation.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: annotation.length,
                            itemBuilder: (context, index) => Row(
                              children: [
                                IconButton(
                                  icon: annotation[index].isshow == 1
                                      ? const Icon(
                                          Icons.visibility,
                                          size: 15,
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          size: 15,
                                        ),
                                  onPressed: () {
                                    if (annotation[index].isshow == 0) {
                                      var anno_json =
                                          annotation[index].annotations;

                                      var ele = elementsFromJson(anno_json);
                                      List<Offset> offset = [];
                                      for (Elements e in ele) {
                                        for (int i = 0;
                                            i < e.points.length;
                                            i++) {
                                          offset.add(Offset(
                                              e.points[i].dx, e.points[i].dy));
                                        }
                                        print(
                                            "Offset :==> " + offset.toString());
                                        var sktype = checkDrawtype(e.type);
                                        sketch.add(Sketch(
                                            id: e.id,
                                            points: offset,
                                            size: e.size,
                                            color: Color(int.parse(e.color)),
                                            type: sktype!,
                                            filled: e.filled,
                                            sides: e.sides));
                                        offset = [];
                                      }
                                      context
                                          .read<AppData>()
                                          .allSketches
                                          .value += List.from(sketch);
                                      context.read<AppData>().notifyChange();
                                      annotation[index].isshow = 1;
                                    } else {
                                      context
                                          .read<AppData>()
                                          .allSketches
                                          .value
                                          .removeWhere((element) =>
                                              element.id ==
                                              annotation[index].annoId);
                                      context.read<AppData>().notifyChange();
                                      annotation[index].isshow = 0;
                                    }
                                  },
                                ),
                                Expanded(
                                    child: Text(
                                        annotation[index].annoName.toString())),
                                IconButton(
                                    onPressed: () {
                                      // var desc = "";
                                      // print(annotation[index].descs.toString());
                                      String desc =
                                          annotation[index].descs.toString();
                                      if (desc == "null") {
                                        print("set null to emtpy");
                                        desc = "";
                                      }
                                      editannoDialog(annotation[index].annoId,
                                          annotation[index].annoName, desc);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 15,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      deleteannoDialog(annotation[index].annoId,
                                          annotation[index].annoName);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 15,
                                    )),
                              ],
                            ),
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 2,
                thickness: 1,
              ),
              Row(
                children: [
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Checkbox(
                      value: context.watch<AppData>().labels,
                      activeColor: Colors.blueGrey,
                      side: const BorderSide(color: Colors.blueGrey),
                      onChanged: (val) {
                        setState(() {
                          context.read<AppData>().labels = val!;
                          context.read<AppData>().notifyChange();
                        });
                      },
                    );
                  }),
                  const Text(
                    'Labels',
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: context.watch<AppData>().annotating == false
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            onPressed: () => annotationDialog(),
                            label: const Text(
                              'New',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            icon: const Icon(
                              Icons.add_box_outlined,
                              color: Colors.blueGrey,
                            ),
                          )
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () async {
                              context.read<AppData>().annotating = false;
                              List<Elements> elements = [];
                              for (Sketch sketch in context
                                  .read<AppData>()
                                  .allSketches
                                  .value) {
                                List<Point> pointtt = [];
                                if (sketch.id ==
                                    context.read<AppData>().parentid.value) {
                                  for (int i = 0;
                                      i < sketch.points.length;
                                      i++) {
                                    pointtt.add(Point(
                                        dx: sketch.points[i].dx,
                                        dy: sketch.points[i].dy));
                                  }
                                  elements.add(Elements(
                                      id: context
                                          .read<AppData>()
                                          .parentid
                                          .value,
                                      size: sketch.size,
                                      type: sketch.type.name.toString(),
                                      color: sketch.color.value.toString(),
                                      sides: sketch.sides,
                                      filled: sketch.filled,
                                      points: pointtt));
                                }
                              }
                              var json = jsonEncode(elements);
                              context.read<AppData>().notifyChange();

                              var data = {
                                "anno_id":
                                    context.read<AppData>().parentid.value,
                                "annotations": json,
                                "anno_name": annoname.value.text,
                                "descs": annodesc.value.text,
                                "created": now.toString(),
                                "creator_id": context.read<AppData>().userid,
                                "item_id": context.read<AppData>().slideid,
                                "updated": now.toString(),
                                "update_id": context.read<AppData>().userid,
                                "isshow": 1
                              };
                              Annotation anno = Annotation.fromJson(data);
                              newAnnotation(anno);
                              context.read<AppData>().annotation =
                                  await loadAnnotation(
                                      context.read<AppData>().slideid);
                              // context
                              //     .read<AppData>()
                              //     .allSketches
                              //     .value
                              //     .removeLast();
                              context.read<AppData>().parentid.value =
                                  randomHexString(25);
                              context.read<AppData>().notifyChange();
                            },
                            label: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(
                              Icons.save_as,
                              color: Colors.white,
                            ),
                          ),
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

Future<void> newAnnotation(Annotation anno) async {
  print('add data');
  //print(anno);
  var result = await post(Uri.parse('http://10.0.2.2:5000/annotation'),
      body: jsonEncode(anno), headers: {'Content-Type': 'application/json'});
  //print(result);
  print(result.statusCode.toString());
}

void updateAnnotation(String id, var anno) async {
  print('update data');
  print(anno["descs"]);
  var result = await patch(Uri.parse('http://10.0.2.2:5000/annotation/' + id),
      body: jsonEncode(anno), headers: {'Content-Type': 'application/json'});
  print(result);
  print(result.statusCode.toString());
}

void deleteAnnotation(String id) async {
  print('delete data');
  var result = await delete(Uri.parse('http://10.0.2.2:5000/annotation/' + id),
      headers: {'Content-Type': 'application/json; charset=UTF-8'});
  print(result);
  print(result.statusCode.toString());
}

Random _random = Random();

String randomHexString(int length) {
  StringBuffer sb = StringBuffer();
  for (var i = 0; i < length; i++) {
    sb.write(_random.nextInt(16).toRadixString(16));
  }
  return sb.toString();
}

SketchType? checkDrawtype(String type) {
  SketchType? sktype;
  if (type == "square") {
    sktype = SketchType.square;
  } else if (type == "circle") {
    sktype = SketchType.circle;
  } else if (type == "scribble") {
    sktype = SketchType.scribble;
  } else if (type == "line") {
    sktype = SketchType.line;
  }
  return sktype;
}

class DrawingMenu extends HookWidget {
  final ValueNotifier<Color> selectedColor;
  final ValueNotifier<double> strokeSize;
  final ValueNotifier<double> eraserSize;
  final ValueNotifier<DrawingMode> drawingMode;
  final ValueNotifier<Sketch?> currentSketch;
  final ValueNotifier<List<Sketch>> allSketches;
  final ValueNotifier<bool> filled;

  const DrawingMenu(
      {super.key,
      required this.selectedColor,
      required this.strokeSize,
      required this.eraserSize,
      required this.drawingMode,
      required this.currentSketch,
      required this.allSketches,
      required this.filled});

  @override
  Widget build(BuildContext context) {
    final exapandsize3 = useState<double>(190);
    //ValueNotifier<List<Sketch>> allSketchess = useState(allSketches.value);
    final undoRedoStack = useState(
      _UndoRedoStack(
        sketchesNotifier: allSketches,
        currentSketchNotifier: currentSketch,
      ),
    );
    List<DrawType> btnDraw = [
      DrawType(
        name: 'pencil',
        icon: const Icon(
          Icons.create,
          size: 15,
        ),
      ),
      DrawType(
        name: 'line',
        icon: const Icon(
          Icons.stacked_line_chart,
          size: 15,
        ),
      ),
      DrawType(
        name: 'square',
        icon: const Icon(
          Icons.square_outlined,
          size: 15,
        ),
      ),
      DrawType(
        name: 'circle',
        icon: const Icon(
          Icons.circle_outlined,
          size: 15,
        ),
      ),
    ];

    List<ColorType> btnColor = [
      ColorType(name: 'red', color: Colors.red),
      ColorType(name: 'blue', color: Colors.blue),
      ColorType(name: 'yellow', color: Colors.yellow),
      ColorType(name: 'green', color: Colors.green),
      ColorType(name: 'black', color: Colors.black),
    ];
    return SizedBox(
      width: 250,
      height: exapandsize3.value,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ExpansionTile(
          leading: const Icon(
            Icons.create,
            color: Colors.white,
          ),
          title: const Text(
            'Draw',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.greenAccent,
          iconColor: Colors.white,
          collapsedBackgroundColor: Colors.greenAccent,
          collapsedIconColor: Colors.white,
          expansionAnimationStyle: AnimationStyle.noAnimation,
          initiallyExpanded: true,
          onExpansionChanged: (value) {
            if (value == false) {
              exapandsize3.value = 58;
            } else {
              exapandsize3.value = 190.0;
            }
          },
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                alignment: Alignment.center,
                color: Colors.black26,
                width: 250,
                height: 1,
              ),
            ),
            Row(
              children: [
                for (int i = 0; i < btnDraw.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: FloatingActionButton(
                        heroTag: 'btn${btnDraw[i].name}',
                        backgroundColor:
                            drawingMode.value.toString().split('.')[1] ==
                                    btnDraw[i].name
                                ? Colors.greenAccent
                                : Colors.white,
                        foregroundColor:
                            drawingMode.value.toString().split('.')[1] ==
                                    btnDraw[i].name
                                ? Colors.white
                                : Colors.black,
                        onPressed: () {
                          //print(btnDraw[i].name);
                          context.read<AppData>().drawing = true;
                          context.read<AppData>().notifyChange();
                          globals.canpan = true;
                          if (btnDraw[i].name == 'pencil') {
                            drawingMode.value = DrawingMode.pencil;
                          } else if (btnDraw[i].name == 'square') {
                            drawingMode.value = DrawingMode.square;
                          } else if (btnDraw[i].name == 'circle') {
                            drawingMode.value = DrawingMode.circle;
                          } else if (btnDraw[i].name == 'line') {
                            drawingMode.value = DrawingMode.line;
                          }
                          //print(drawingMode.value.toString().split('.')[1]);
                        },
                        child: btnDraw[i].icon,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Fill : ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Checkbox(
                          value: filled.value,
                          activeColor: Colors.blueGrey,
                          side: const BorderSide(color: Colors.blueGrey),
                          onChanged: (val) {
                            setState(() {
                              filled.value = val!;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                for (int i = 0; i < btnColor.length; i++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: FloatingActionButton(
                        backgroundColor: btnColor[i].color,
                        heroTag: 'btn${btnColor[i].name}',
                        onPressed: () {
                          selectedColor.value = btnColor[i].color;
                          context.read<AppData>().drawing = true;
                          context.read<AppData>().notifyChange();
                        },
                        child: selectedColor.value == btnColor[i].color
                            ? const Icon(
                                Icons.arrow_downward_rounded,
                                size: 10,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black26,
                    width: 2,
                    height: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: () {
                        strokeSize.value = 3.0;
                        context.read<AppData>().drawing = true;
                        context.read<AppData>().notifyChange();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color:
                            strokeSize.value == 3 ? Colors.red : Colors.black,
                        width: 25,
                        height: 3,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: () {
                        strokeSize.value = 6.0;
                        context.read<AppData>().drawing = true;
                        context.read<AppData>().notifyChange();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color:
                            strokeSize.value == 6 ? Colors.red : Colors.black,
                        width: 25,
                        height: 6,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onTap: () {
                        strokeSize.value = 9.0;
                        context.read<AppData>().drawing = true;
                        context.read<AppData>().notifyChange();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color:
                            strokeSize.value == 9 ? Colors.red : Colors.black,
                        width: 25,
                        height: 9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Wrap(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: allSketches.value.isNotEmpty
                      ? () => undoRedoStack.value.undo()
                      : null,
                  child: const Text('Undo'),
                  //child: const Text('Undo'),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: undoRedoStack.value._canRedo,
                  builder: (_, canRedo, __) {
                    return TextButton(
                      onPressed:
                          canRedo ? () => undoRedoStack.value.redo() : null,
                      child: const Text('Redo'),
                    );
                  },
                ),
                TextButton(
                  child: const Text('Clear'),
                  onPressed: () => undoRedoStack.value.clear(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PanandLock extends HookWidget {
  const PanandLock({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<AppData>().drawing = !context.read<AppData>().drawing;
        context.read<AppData>().notifyChange();
      },
      backgroundColor: Colors.greenAccent,
      foregroundColor: Colors.white,
      child: context.watch<AppData>().drawing == false
          ? const Icon(Icons.pan_tool)
          : const Icon(Icons.lock),
    );
  }
}

class ZoomX {
  final String xtext;
  double xvalue;

  ZoomX({required this.xtext, required this.xvalue});
}

class DrawType {
  final String name;
  Icon icon;

  //bool selecting = false;

  DrawType({required this.name, required this.icon});
}

class ColorType {
  final String name;
  final Color color;

  ColorType({required this.name, required this.color});
}

class _UndoRedoStack {
  _UndoRedoStack({
    required this.sketchesNotifier,
    required this.currentSketchNotifier,
  }) {
    _sketchCount = sketchesNotifier.value.length;
    sketchesNotifier.addListener(_sketchesCountListener);
  }

  final ValueNotifier<List<Sketch>> sketchesNotifier;
  final ValueNotifier<Sketch?> currentSketchNotifier;

  ///Collection of sketches that can be redone.
  late final List<Sketch> _redoStack = [];

  ///Whether redo operation is possible.
  ValueNotifier<bool> get canRedo => _canRedo;
  late final ValueNotifier<bool> _canRedo = ValueNotifier(false);

  late int _sketchCount;

  void _sketchesCountListener() {
    if (sketchesNotifier.value.length > _sketchCount) {
      //if a new sketch is drawn,
      //history is invalidated so clear redo stack
      _redoStack.clear();
      _canRedo.value = false;
      _sketchCount = sketchesNotifier.value.length;
    }
  }

  void clear() {
    _sketchCount = 0;
    sketchesNotifier.value = [];
    _canRedo.value = false;
    currentSketchNotifier.value = null;
  }

  void undo() {
    //print('undo');
    final sketches = List<Sketch>.from(sketchesNotifier.value);
    if (sketches.isNotEmpty) {
      _sketchCount--;
      _redoStack.add(sketches.removeLast());
      sketchesNotifier.value = sketches;
      _canRedo.value = true;
      currentSketchNotifier.value = null;
    }
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final sketch = _redoStack.removeLast();
    _canRedo.value = _redoStack.isNotEmpty;
    _sketchCount++;
    sketchesNotifier.value = [...sketchesNotifier.value, sketch];
  }

  void dispose() {
    sketchesNotifier.removeListener(_sketchesCountListener);
  }
}

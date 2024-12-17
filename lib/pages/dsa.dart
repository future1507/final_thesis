import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:histomictk/models/collection.dart';
import 'package:histomictk/models/folder.dart';
import 'package:histomictk/models/item.dart';
import 'package:histomictk/pages/annotate.dart';
import 'package:http/http.dart';
import 'package:histomictk/global.dart' as globals;
import 'package:intl/intl.dart';
import 'package:histomictk/service/provider/appdata.dart';
import 'package:provider/provider.dart';

class DSA extends StatefulWidget {
  const DSA({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DSAState();
  }
}

class _DSAState extends State<DSA> {
  List<Collection> collections = [];
  List<Folder> folders = [];
  List<Item> items = [];
  var isloadfolder = false;
  var isloaditem = false;
  String previousfolder = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      collections = await loadCollection();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 0, MediaQuery.sizeOf(context).width / 15, 0),
              child: const Text(
                'Collection',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  0, 0, MediaQuery.sizeOf(context).width / 100, 0),
              child: FloatingActionButton(
                heroTag: 'btn1',
                shape: const CircleBorder(),
                backgroundColor: const Color.fromRGBO(63, 71, 96, 1),
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 10,
              height: 100,
              child: const VerticalDivider(),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.sizeOf(context).width / 50),
              child: const Text(
                'Slides',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    onSubmitted: (value) async {
                      items = await loadsearchItems(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      hintText: "Search",
                      fillColor: Colors.white70,
                    ),
                  ),
                ),
                //
                if (collections.isNotEmpty)
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: collections.length,
                    itemBuilder: (context, index) => ExpansionTile(
                      title: Text(collections[index].name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Created on ${formatDatetime(collections[index].created)}'),
                      trailing: Text(
                          getFileSizeString(bytes: collections[index].size)),
                      children: [
                        Text(collections[index].description ?? ''),
                      ],
                      onExpansionChanged: (value) async {
                        folders = await loadFolder('collection',
                            collections[index].id, collections[index].name);
                        setState(() {
                          isloadfolder = true;
                        });
                      },
                    ),
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  )
              ],
            ),
          ),
          Container(
            color: const Color.fromRGBO(63, 71, 96, 1),
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, 0, 0, MediaQuery.sizeOf(context).height / 50),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RotatedBox(
                        quarterTurns: -1,
                        child: Text('Back to cases',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22)),
                      )
                    ],
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'btn2',
                  shape: const CircleBorder(),
                  backgroundColor: Colors.greenAccent,
                  onPressed: () {
                    // globals.slideid = items[index].id;
                    // globals.slidename = items[index].name;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Annotate()));
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (isloadfolder == true)
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  SingleChildScrollView(
                    child: Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: folders.length,
                            itemBuilder: (context, index) => ListTile(
                              leading: const Icon(Icons.folder),
                              title: Text(folders[index].name),
                              onTap: () async {
                                folders = await loadFolder('folder',
                                    folders[index].id, folders[index].name);
                                setState(() {
                                  //print(isloaditem);
                                });
                              },
                            ),
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                          )
                        ])),
                  )
                ],
              ),
            ),
          if (isloaditem == true)
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.all(MediaQuery.sizeOf(context).width / 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(previousfolder,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Number of slides: ${items.length} slides',
                            style: const TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                // globals.slideid = items[index].id;
                                // globals.slidename = items[index].name;
                                context.read<AppData>().slideid =
                                    items[index].id;
                                context.read<AppData>().slidename =
                                    items[index].name;
                                context.read<AppData>().notifyChange();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Annotate()));
                              },
                              leading: Container(
                                // width: 160,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black26, width: 1)),
                                child: Image.network(
                                  'https://demo.kitware.com/histomicstk/api/v1/item/${items[index].id}/tiles/thumbnail?width=160&height=100',
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(
                                        Icons.file_present_outlined);
                                  },
                                ),
                              ),
                              title: Text(items[index].name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'Create on ${formatDatetime(items[index].created)}\nUpdate on ${formatDatetime(items[index].updated)}'),
                              trailing: Text(
                                  getFileSizeString(bytes: items[index].size)),
                            ),
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                          ),
                        ])),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<List<Collection>> loadCollection() async {
    var response = await get(Uri.parse('https://${globals.ip}/collection'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'Girder-Token': globals.token
        });
    var collection = collectionFromJson(response.body);
    return collection;
  }

  Future<List<Folder>> loadFolder(var type, var id, var fname) async {
    var response = await get(
        Uri.parse(
            '${'https://' + globals.ip + '/folder?parentType=' + type}&parentId=' +
                id),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'Girder-Token': globals.token
        });
    //print(response.body.length);
    if ((response.body).length <= 2) {
      isloaditem = true;
      previousfolder = fname;
      items = await loadItems(id);
      isloadfolder = false;
    } else {
      isloaditem = false;
    }
    var folder = folderFromJson(response.body);
    return folder;
  }

  Future<List<Item>> loadItems(var id) async {
    var response = await get(
        Uri.parse('${'https://${globals.ip}/item?folderId=' + id}&limit=200'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'Girder-Token': globals.token
        });
    var item = itemFromJson(response.body);
    return item;
  }

  Future<List<Item>> loadsearchItems(String text) async {
    var response = await get(
        Uri.parse('${'https://${globals.ip}/item?text=' + text}'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          'Girder-Token': globals.token
        });
    var item = itemFromJson(response.body);
    print(response.body);
    isloadfolder = false;
    isloaditem = true;
    return item;
  }

  static String getFileSizeString({required int bytes, int decimals = 4}) {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsPrecision(decimals)) + suffixes[i];
  }

  static String formatDatetime(DateTime date) {
    String formatdate = DateFormat('dd/MM/yyyy At kk:mm').format(date);
    return formatdate;
  }
}

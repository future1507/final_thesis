import 'package:flutter/material.dart';

class Testui extends StatefulWidget {
  const Testui({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TestuiState();
  }
}

class _TestuiState extends State<Testui> {
  @override
  static const loremIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, '
      'sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad '
      'minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
      'commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit '
      'esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat '
      'non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  static const time = 'January 10,2021 (19:20:37)';
  final List<Item> items = [
    Item(header: 'Liver cancer', times: time, body: loremIpsum),
    Item(header: 'Tuberculosis', times: time, body: loremIpsum),
    Item(header: 'COVID-19', times: time, body: loremIpsum),
    Item(header: 'Knee osteoarthritis', times: time, body: loremIpsum),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 150, 0),
              child: Text(
                'Collection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child:
                  ElevatedButton(onPressed: () {}, child: const Icon(Icons.settings)),
            ),
            Container(
              alignment: Alignment.center,
              width: 1,
              height: 400,
              child: const VerticalDivider(),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Slide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                ),
              ),
            )
          ],
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ListView(
                children: const [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search',
                    ),
                  ),
                  ExpansionTile(
                    title: Text("Liver cancer"),
                    children: [Text(time), Text(loremIpsum)],
                  ),
                  ExpansionTile(
                    title: Text("Tuberculosis"),
                    children: [Text(time), Text(loremIpsum)],
                  ),
                  ExpansionTile(
                    title: Text("COVID-19"),
                    children: [Text(time), Text(loremIpsum)],
                  ),
                  ExpansionTile(
                    title: Text("Knee osteoarthritis"),
                    children: [Text(time), Text(loremIpsum)],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              width: 50,
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('HN001'),Text('Number of slides: 10 slides')
                    ],
                  ),
                  SingleChildScrollView(
                    child: Card(
                        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Image.asset('img/23.png'),
                            title: const Text('dasdda25'),
                            subtitle: const Text('January 10, 2021 (19:20:37) \n'
                                'January 10, 2021 (19:20:37)'),
                          ),
                          const Divider(),
                        ])),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class Item {
  final String header;
  final String times;
  final String body;
  bool isExpanded;

  Item({required this.header,
    required this.times,
    required this.body,
    this.isExpanded = false});
}

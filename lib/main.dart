import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var name = ['김영숙', '홍길동', '피자집'];
  var total = 3;
  String people = '';

  void addOne(inputData) {
    setState(() {
      total++;
      name.add(inputData.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return DialogUI(
                addOne: addOne,
              );
            });
      }),
      appBar: AppBar(
        title: Text(
          '연락처  ${total.toString()}',
        ),
      ),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: const Icon(
              Icons.account_circle,
              size: 44,
            ),
            title: Text(
              name[i],
              style: const TextStyle(fontSize: 17),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavi(),
    );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({
    super.key,
    this.addOne,
  });

  final addOne;

  var inputData = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Contact'),
      content: TextField(
        controller: inputData,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                if (inputData.text == '') {
                  return;
                } else {
                  addOne(inputData);
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Ok',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BottomNavi extends StatelessWidget {
  const BottomNavi({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomAppBar(
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.call),
            Icon(Icons.chat),
            Icon(Icons.contact_page_rounded),
          ],
        ),
      ),
    );
  }
}

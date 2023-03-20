import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

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
  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      setState(() {
        name = contacts;
        total = name.length;
      });
    } else if (status.isDenied) {
      print('거절됨');
      // 허용 요구 팝업
      Permission.contacts.request();
      // 앱 설정화면
      //openAppSettings();
    }
  }

  var name = [];
  var total = 0;

  String people = '';

  void addOne(inputData) {
    setState(() {
      total++;
      var newContacts = Contact();
      newContacts.givenName = inputData.text;
      ContactsService.addContact(newContacts);
      // name.add(inputData.text);
      name.add(newContacts);
    });
  }

  void deleteOne(deleteAccount) {
    setState(() {
      total = total - 1;
      ContactsService.deleteContact(deleteAccount);
      name.remove(deleteAccount);
    });
  }

  void stringSort() {
    setState(() {
      name.sort((a, b) =>
          a.displayName.compareTo(b.displayName) ??
          a.givenName.compareTo(b.givenName));
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
        actions: [
          IconButton(
            onPressed: () {
              getPermission();
            },
            icon: const Icon(
              Icons.manage_accounts,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              stringSort();
            },
            icon: const Icon(
              Icons.sort,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: name.length,
          itemBuilder: (context, i) {
            return ListTile(
              leading: const Icon(
                Icons.account_circle,
                size: 44,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (name[i].displayName ?? name[i].givenName),
                    //name[i],
                    style: const TextStyle(fontSize: 17),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteOne(name[i]);
                    },
                    child: const Text(
                      "삭제",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
      title: const Text(
        '연락처 추가',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: TextField(
        decoration: InputDecoration(
          icon: Icon(
            Icons.star,
            color: Colors.amber.shade400,
          ),
          enabledBorder: const UnderlineInputBorder(),
          hintText: '이름',
        ),
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
        height: 63,
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

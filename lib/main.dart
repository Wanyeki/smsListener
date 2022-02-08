import 'package:flutter/material.dart';
import 'package:smslistener/inputs.dart';
import 'package:smslistener/services.dart';
import 'package:telephony/telephony.dart';

void main() {
  runApp(const MyApp());
}

final Telephony telephony = Telephony.instance;
backgrounMessageHandler(SmsMessage message) async {
  await postMessage(message, "background");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Listener',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  InputScreen({Key? key}) : super(key: key);

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final listenerFormKey = GlobalKey<FormState>();
  bool loading = false;
  String status = 'listening';
  String body = '', address = '', message = '';
  Map savedData = {"url": '', "sender": ""};
  @override
  void initState() {
    super.initState();
    listenMessage();
  }

  listenMessage() async {
    Map data = await getData();
    setState(() {
      savedData = data;
    });
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage mess) async {
          try {
            String messag = await postMessage(mess, "foreground");
            setState(() {
              body = mess.body ?? '';
              address = mess.address ?? '';
              message = messag;
            });
          } on dynamic catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(e.message ?? 'an error occured')
              ],
            )));
          }
        },
        onBackgroundMessage: backgrounMessageHandler);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController =
            TextEditingController(text: savedData["url"]),
        senderController = TextEditingController(text: savedData["sender"]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Listener'),
      ),
      body: Center(
        child: Form(
          key: listenerFormKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                status,
                textAlign: TextAlign.center,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              BorderInput(
                name: 'url',
                prefixIcon: const Icon(Icons.link),
                controller: urlController,
              ),
              const SizedBox(
                height: 30,
              ),
              BorderInput(
                name: 'sender',
                controller: senderController,
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 30,
              ),
              FilledButton(
                  onPressed: () async {
                    if (listenerFormKey.currentState!.validate()) {
                      Map data = {
                        "url": urlController.text,
                        "sender": senderController.text
                      };
                      setState(() {
                        loading = true;
                      });
                      await savedata(data);
                      setState(() {
                        savedData = data;
                        loading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Data updated")
                        ],
                      )));
                    }
                  },
                  color: Colors.blue[400] ?? Colors.blue,
                  disabled: loading,
                  text: "Update"),
              const SizedBox(height: 30),
              Text(
                address,
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

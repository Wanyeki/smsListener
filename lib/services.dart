import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

savedata(data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('items', <String>[data["url"], data['sender']]);
}

getData() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? items = prefs.getStringList('items');
  if (items == null) {
    return {"url": "", "sender": "any"};
  } else {
    return {"url": items[0], "sender": items[1]};
  }
}

postMessage(SmsMessage message, String from) async {
  Map data = {"sender": message.address, "message": message.body, "from": from};
  Map info = await getData();
  try {
    Uri url = Uri.parse(info['url']);
    if (message.address == info["sender"] || info['sender'] == "any") {
      http.post(url, body: data);
      return 'sent';
    }
  } catch (e) {
    if (from == 'foreground') {
      throw e;
    }
  }
}

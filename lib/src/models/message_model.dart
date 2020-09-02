import 'dart:convert';

import 'package:d2shop_admin/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class Message {
  static const String serverToken = 'AAAA97iVVhA:APA91bFLwVMERV7pUrXjIcQGtaklgNspBhIMeXmqKn8excqVHHBGs4RsjgiMNu--s4-WkejPqLHG1ZyrSQPOV7sPFwrmX3pKLUZ77eJ5odtCdCegy15-y2mEicLYb1qR0yXGk8x37E8y';
  final String title, body, imageUrl;
  String date;

  Message({this.title, this.body, this.imageUrl, this.date});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'date': DateTime.now().toString()
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      title: json['title'],
      body: json['body'],
      imageUrl: json['imageUrl'],
      date: json['date'],
    );
  }

  final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverToken',
  };

  Map<String, dynamic> notificationData = <String, dynamic>{
    'notification': <String, dynamic>{},
    'priority': 'high',
    'data': <String, dynamic>{
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done'
    },
    'to': '/topics/notify',
  };

  Future<bool> sendNotification() async {
    try {
      assert(serverToken.isNotEmpty);
      notificationData['notification']['title'] = title;
      notificationData['notification']['body'] = body;
      if (imageUrl != null)
        notificationData['notification']['image'] = imageUrl;

      return await http
          .post(
        'https://fcm.googleapis.com/fcm/send',
        headers: headers,
        body: jsonEncode(notificationData),
      )
          .then((value) {
        if (value.statusCode == 200)
          return true;
        else
          return false;
      });
    } catch (e) {
      Utils.showMessage(e);
      return false;
    }
  }
}

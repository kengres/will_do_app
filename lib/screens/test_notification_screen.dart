import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:will_do/plugins/notifications_plugin.dart';

class TestNotificationScreen extends StatefulWidget {
  @override
  _TestNotificationScreenState createState() => _TestNotificationScreenState();
}

class _TestNotificationScreenState extends State<TestNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notPlgn = Provider.of<NotificationPlugin>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Immediate notification"),
              onPressed: () {
                notPlgn.showNotification(
                  1,
                  "You have a new message",
                  "This part will hold very valuable information one day."
                );
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("Notification in 10s"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                try {
                  final time = DateTime.now().add(Duration(seconds: 10));
                  print("scheduled for ${time.toString()}");
                  await notPlgn.scheduleNotification(time, 3, "Schedule for 10s", "This is a notification you scheduled 1 minute age");
                } catch (e) {
                  print("error ${e.toString()}");
                }
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("Notification in 1 min"),
              onPressed: () async {
                final time = DateTime.now().add(Duration(minutes: 1));
                print("scheduled for ${time.toString()}");
                await notPlgn.scheduleNotification(time, 4, "Schedule for 1 min", "This is a notification you scheduled 1 minute age");
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("Notification in 5min"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                final time = DateTime.now().add(Duration(minutes: 5));
                print("scheduled for ${time.toString()}");
                await notPlgn.scheduleNotification(time, 4, "Schedule for 5 min", "This is a notification you scheduled 1 minute age");
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("Notification in 5 s"),
              onPressed: () async {
                await notPlgn.debugNotification();
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("All Notifications"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                final List<PendingNotificationRequest> all = await notPlgn.getScheduledNotifications();
                print("we have ${all.length} pending notifications...");
                if (all.length > 1) {
                  print("example of notification: ");
                  print(all[1].id);
                  print(all[1].title);
                }
              }
            ),
          ]
        ),
      ),
    );
  }
}

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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
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
              child: Text("Notification in 5 s"),
              onPressed: () async {
                await notPlgn.debugNotification();
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
              child: Text("Notification in 20 sec"),
              onPressed: () async {
                final time = DateTime.now().add(Duration(seconds: 20));
                print("scheduled for ${time.toString()}");
                await notPlgn.scheduleNotification(time, 4, "Schedule for 20 sec", "This is a notification you scheduled 1 minute age");
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("Notification periodically"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                print("scheduled for every 2 min");
                await notPlgn.periodicNotification("periodically notification", "This is a notification you scheduled every minute");
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("All Notifications"),
              onPressed: () async {
                final List<PendingNotificationRequest> all = await notPlgn.getScheduledNotifications();
                print("we have ${all.length} pending notifications...");
                for (var i = 0; i < all.length; i++) {
                  print("=========== Pending notification ${all[i].id}: ");
                  print(all[i].title);
                }
                final snackBar = SnackBar(
                  content: Text("We have ${all.length} pending notifications"),
                  backgroundColor: Colors.deepOrange,
                );
                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            ),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("Cancel Notifications"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () async {
                await notPlgn.cancelAllNotifications();
              }
            ),
          ]
        ),
      ),
    );
  }
}

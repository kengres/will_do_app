class NotificationData {
  static const String idField = 'id';
  static const String notificationIdField = 'notificationId';
  static const String titleField = 'title';
  static const String descriptionField = 'description';
  static const String hourField = 'hour';
  static const String minuteField = 'minute';

  String id;
  int notificationId;
  String title;
  String description;
  int hour;
  int minute;

  NotificationData(this.title, this.description, this.hour, this.minute);
}
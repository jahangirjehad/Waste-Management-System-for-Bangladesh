class NotificationItemModel {
  final int id;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  NotificationItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      time: json['time'],
      isRead: json['isRead'],
    );
  }
}

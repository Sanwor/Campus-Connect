class EventModel {
  final int id;
  final String eventTitle;
  final String eventDate;
  final String startTime;
  final String endTime;
  final String eventDetail;
  final String location;
  final String? image;

  EventModel({
    required this.id,
    required this.eventTitle,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.eventDetail,
    required this.location,
    this.image,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      eventTitle: json['event_title'] ?? '',
      eventDate: json['event_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      eventDetail: json['event_detail'] ?? '',
      location: json['location'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_title': eventTitle,
      'event_date': eventDate,
      'start_time': startTime,
      'end_time': endTime,
      'event_detail': eventDetail,
      'location': location,
      'image': image,
    };
  }
}
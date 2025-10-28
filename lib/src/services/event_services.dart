import 'package:dio/dio.dart';

class EventService {
  final Dio _dio;

  EventService(this._dio);

  // Get all events
  Future<Response> getEvents() async {
    return await _dio.get('events/');
  }

  // Get single event detail
  Future<Response> getEventDetail(int id) async {
    return await _dio.get('events/$id/');
  }

  // Create event
  Future<Response> createEvent(FormData formData, String token) async {
  return await _dio.post(
    'events/',
    data: formData,
    options: Options(
      headers: {
        "Authorization": "Bearer $token", // Add your user's auth token
        "Content-Type": "application/json", // FormData requires this
      },
    ),
  );
}

  // Update event
  Future<Response> updateEvent(int id, FormData formData) async {
    return await _dio.patch(
      'events/$id/',
      data: formData,
    );
  }

  // Delete event
  Future<Response> deleteEvent(int id) async {
    return await _dio.delete('events/$id/');
  }
}
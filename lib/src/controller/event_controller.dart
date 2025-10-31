import 'dart:developer';
import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/model/event_model.dart';
import 'package:campus_connect/src/services/event_services.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';

class EventController extends GetxController {
  final EventService _eventService = Get.find();
  RxBool isLoading = false.obs;
  RxList<EventModel> eventList = <EventModel>[].obs;
  Rx<EventModel?> eventDetails = Rx<EventModel?>(null);
  RxBool isEventPostLoading = false.obs;
  RxBool isEventPatchLoading = false.obs;
  RxBool isEventDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    getEvents();
  }

  // Get all events
  getEvents() async {
    isLoading.value = true;
    try {
      final response = await _eventService.getEvents();
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<EventModel> listOfData = [];
        for (var data in response.data) {
          listOfData.add(EventModel.fromJson(data));
        }
        eventList.value = listOfData;
        log('✅ Successfully loaded ${eventList.length} events');
      }
    } catch (e) {
      log('❌ Error fetching events: $e');
      if (e is DioException) {
        log('Dio Error: ${e.message}');
        log('Response: ${e.response?.data}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Get single event details
  getEventDetails(int id) async {
    try {
      final response = await _eventService.getEventDetail(id);
      if (response.statusCode == 200) {
        eventDetails.value = EventModel.fromJson(response.data);
      }
    } catch (e) {
      log('❌ Error fetching event details: $e');
    }
  }

  // Create event
  createEvent({
    required String eventTitle,
    required String eventDate,
    required String startTime,
    required String endTime,
    required String eventDetail,
    required String location,
    String? imagePath,
  }) async {
    isEventPostLoading.value = true;
    try {
      Map<String, dynamic> formMap = {
        "event_title": eventTitle,
        "event_date": eventDate,
        "start_time": startTime,
        "end_time": endTime,
        "event_detail": eventDetail,
        "location": location,
      };

      if (imagePath != null) {
        formMap["image"] = await MultipartFile.fromFile(imagePath);
      }

      FormData formData = FormData.fromMap(formMap);
      final token = read("access_token");

      final response = await _eventService.createEvent(formData, token);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        showToast("Event created successfully!");
        await getEvents(); // Refresh list
      }
    } catch (e) {
      log("❌ Error creating event: $e");
      showToast("Failed to create event");
    } finally {
      isEventPostLoading.value = false;
    }
  }

  // Update event
  updateEvent(
    int id, {
    String? eventTitle,
    String? eventDate,
    String? startTime,
    String? endTime,
    String? eventDetail,
    String? location,
    String? imagePath,
  }) async {
    isEventPatchLoading.value = true;
    try {
      Map<String, dynamic> formMap = {};
      
      // Only include fields that are provided
      if (eventTitle != null) formMap["event_title"] = eventTitle;
      if (eventDate != null) formMap["event_date"] = eventDate;
      if (startTime != null) formMap["start_time"] = startTime;
      if (endTime != null) formMap["end_time"] = endTime;
      if (eventDetail != null) formMap["event_detail"] = eventDetail;
      if (location != null) formMap["location"] = location;

      if (imagePath != null) {
        formMap["image"] = await MultipartFile.fromFile(imagePath);
      }

      FormData formData = FormData.fromMap(formMap);

      final response = await _eventService.updateEvent(id, formData);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        showToast('Event updated successfully!');
        getEvents(); // Refresh list
      }
    } catch (e) {
      log("❌ Error updating event: $e");
    } finally {
      isEventPatchLoading.value = false;
    }
  }

  // Delete event
  deleteEvent(int id) async {
    try {
      isEventDeleting.value = true;
      final response = await _eventService.deleteEvent(id);

      if (response.statusCode == 200 || response.statusCode == 204) {
        showToast("Event deleted successfully");
        log("✅ Event with id $id deleted successfully");
        await getEvents(); // Refresh list
      }
    } catch (e) {
      log("❌ Error deleting event: ${e.toString()}");
      showToast("Failed to delete event");
    } finally {
      isEventDeleting.value = false;
    }
  }

  // Refresh events
  refreshEvents() async {
    await getEvents();
  }

  void showToast(String message) {
    Get.snackbar(
      'Event',
      message,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
  }
}
import 'dart:io';
import 'package:campus_connect/src/controller/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvent extends StatefulWidget {
  final bool isUpdate;
  final int? eventId;

  const CreateEvent({super.key, required this.isUpdate, this.eventId});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final EventController eventCon = Get.find<EventController>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  File? selectedImage;
  String? existingImageUrl; // Add this to store existing image URL

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.eventId != null) {
      final event = eventCon.eventList.firstWhereOrNull((e) => e.id == widget.eventId);

      if (event != null) {
        titleController.text = event.eventTitle;
        detailController.text = event.eventDetail;
        locationController.text = event.location;
        dateController.text = event.eventDate;
        startTimeController.text = event.startTime;
        endTimeController.text = event.endTime;
        existingImageUrl = event.image;
      }
        }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toIso8601String().split("T").first;
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formatted =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      setState(() => controller.text = formatted);
    }
  }

  void _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.isUpdate) {
      await eventCon.updateEvent(
        widget.eventId!,
        eventTitle: titleController.text.trim(),
        eventDate: dateController.text.trim(),
        startTime: startTimeController.text.trim(),
        endTime: endTimeController.text.trim(),
        eventDetail: detailController.text.trim(),
        location: locationController.text.trim(),
        imagePath: selectedImage?.path,
      );
    } else {
      await eventCon.createEvent(
        eventTitle: titleController.text.trim(),
        eventDate: dateController.text.trim(),
        startTime: startTimeController.text.trim(),
        endTime: endTimeController.text.trim(),
        eventDetail: detailController.text.trim(),
        location: locationController.text.trim(),
        imagePath: selectedImage?.path,
      );
    }


    eventCon.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? 'Update Event' : 'Create Event',style: TextStyle(
          fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
        ),),
        
        centerTitle: true,
        backgroundColor: const Color(0xff020826),
        leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: const Color(0xffFFFFFF),
                ))
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff020826), Color(0xff204486)],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(titleController, "Event Title"),
                _buildDatePicker(dateController, "Event Date", _selectDate),
                _buildTimePicker(
                    startTimeController, "Start Time", _selectTime),
                _buildTimePicker(endTimeController, "End Time", _selectTime),
                _buildTextField(detailController, "Event Detail", maxLines: 4),
                _buildTextField(locationController, "Location"),
                SizedBox(height: 15.h),

                // Image picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Fixed: withValues to withOpacity
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.file(selectedImage!,
                                fit: BoxFit.cover, width: double.infinity),
                          )
                        : existingImageUrl != null && existingImageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  existingImageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Text(
                                        "Tap to choose new image",
                                        style: TextStyle(
                                            color: Colors.white70, fontSize: 14.sp),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Tap to choose image",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14.sp),
                                ),
                              ),
                  ),
                ),

                SizedBox(height: 30.h),
                Obx(() => SizedBox(
  width: 260.w,
  height: 50.h,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff193670), // Same blue as login button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0.r), // Same border radius
        side: const BorderSide(
          color: Colors.white,
          width: 2,
        ),
      ),
    ),
    onPressed: eventCon.isEventPostLoading.value || eventCon.isEventPatchLoading.value
        ? null // disable while loading
        : _submitEvent,
    child: eventCon.isEventPostLoading.value || eventCon.isEventPatchLoading.value
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Text(
            widget.isUpdate ? "UPDATE EVENT" : "POST EVENT",
            style: TextStyle(
              color: const Color(0xffFFFFFF), // White text like login button
              fontSize: 16.sp,
            ),
          ),
  ),
))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        maxLines: maxLines,
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController controller, String hint,
      VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(color: Colors.white),
        onTap: onTap,
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(TextEditingController controller, String hint,
      Function(TextEditingController) onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(color: Colors.white),
        onTap: () => onTap(controller),
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          suffixIcon: const Icon(Icons.access_time, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

import 'package:campus_connect/src/app_utils/read_write.dart';
import 'package:campus_connect/src/controller/event_controller.dart';
import 'package:campus_connect/src/view/create_event.dart'; 
import 'package:campus_connect/src/widgets/custom_alerts.dart';
import 'package:campus_connect/src/widgets/event_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventController eventCon = Get.put(EventController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void initialise() async {
    await eventCon.getEvents();
  }

  void _onSearchChanged(String query) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = read("isAdmin") == "true";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff020826),
        centerTitle: true,
        title: Text(
          'Events',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: const Color(0xffFFFFFF),
        )),
        actions: [
          isAdmin
              ? IconButton(
                  onPressed: () {
                    Get.to(() => const CreateEvent(isUpdate: false,));
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                )
              : SizedBox(width: 40.w),
        ],
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
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () => eventCon.getEvents(),
            child: eventCon.isLoading.isTrue
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : eventCon.eventList.isEmpty
                    ? Center(
                        child: Text(
                          "No Events Found",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 20.h),
                        child: Column(
                          children: [
                            // 🔍 Search Bar
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: TextField(
                                controller: searchController,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search events...",
                                  hintStyle:
                                      const TextStyle(color: Colors.white70),
                                  prefixIcon: const Icon(Icons.search,
                                      color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),

                            // 📅 Event List
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                              padding: EdgeInsets.only(bottom: 30.h),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: eventCon.eventList.length,
                              itemBuilder: (context, index) {
                                final event = eventCon.eventList[index];
                                final query =
                                    searchController.text.trim().toLowerCase();
                                final matches = query.isEmpty ||
                                    (event.eventTitle.toLowerCase().contains(query));

                                if (!matches) return const SizedBox.shrink();

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: EventContainer(
                                    eventTitle: event.eventTitle,
                                    eventDate: event.eventDate,
                                    startTime: event.startTime,
                                    endTime: event.endTime,
                                    location: event.location,
                                    imageUrl: event.image,
                                    onTap: () => _showEventDetails(event),
                                    onTapMenu: (value) async {
                                      if (value == 'delete') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomAlert(
                                              title: 'Delete Event',
                                              content:
                                                  'Do you want to delete this event?',
                                              onTap: () async {
                                                await eventCon
                                                    .deleteEvent(event.id);
                                                Get.back();
                                                eventCon.getEvents();
                                              },
                                            );
                                          },
                                        );
                                      } else if (value == 'update') {
                                        Get.to(() => CreateEvent(
                                              isUpdate: true,
                                              eventId: event.id,
                                            ));
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  void _showEventDetails(event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff204486),
        title: Text(
          'Event Details',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Title', event.eventTitle),
              _buildDetailRow('Date', event.eventDate),
              _buildDetailRow('Time', '${event.startTime} - ${event.endTime}'),
              _buildDetailRow('Location', event.location),
              _buildDetailRow('Description', event.eventDetail),
              if (event.image != null) SizedBox(height: 10.h),
              if (event.image != null)
                Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: NetworkImage(event.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

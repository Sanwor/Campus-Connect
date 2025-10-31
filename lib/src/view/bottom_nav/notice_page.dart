import 'package:campus_connect/src/controller/auth_controller.dart';
import 'package:campus_connect/src/controller/notice_controller.dart';
import 'package:campus_connect/src/view/create_notice.dart';
import 'package:campus_connect/src/view/notice_details.dart';
import 'package:campus_connect/src/widgets/custom_alerts.dart';
import 'package:campus_connect/src/widgets/notice_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app_utils/read_write.dart';

class NoticePage extends StatefulWidget {
  final AuthController authController = Get.find<AuthController>();
  NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final NoticeController noticeCon = Get.put(NoticeController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() async {
    await noticeCon.getNoticeList();
  }

  void _onSearchChanged(String query) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove extendBodyBehindAppBar to prevent scroll overlap
      appBar: AppBar(
        backgroundColor: const Color(0xff020826),
        centerTitle: true,
        title: Text(
          'Notices',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          read("isAdmin") == "true"
              ? IconButton(
                  onPressed: () {
                    Get.to(() => CreateNotice(isUpdate: false));
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
            onRefresh: () => noticeCon.getNoticeList(),
            child: noticeCon.isNoticeLoading.isTrue
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : noticeCon.noticeList.isEmpty
                    ? Center(
                        child: Text(
                          "Notice List is Empty",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 20.h),
                        child: Column(
                          children: [
                            // Search Bar
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: TextField(
                                controller: searchController,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search notices...",
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

                            // Notice List
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                              padding: EdgeInsets.only(bottom: 30.h),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: noticeCon.noticeList.length,
                              itemBuilder: (context, index) {
                                final notice = noticeCon.noticeList[index];
                                final query = searchController.text
                                    .trim()
                                    .toLowerCase();
                                final matches = query.isEmpty ||
                                    (notice.title
                                            ?.toLowerCase()
                                            .contains(query) ??
                                        false);

                                if (!matches) return const SizedBox.shrink();

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: NoticeContainer(
                                    title: notice.title.toString(),
                                    dateTime: notice.publishedAt.toString(),
                                    onTap: () => Get.to(() => NoticeDetails(
                                        noticeid:noticeCon.noticeList[index].id,
                                        )),
                                    onTapMenu: (value) async {
                                      if (value == 'delete') {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomAlert(
                                              title: 'Delete',
                                              content:'Do you want to delete this notice?',
                                              onTap: () async {
                                                await noticeCon.deleteNotice(noticeCon.noticeList[index].id);
                                                if (context.mounted) {Navigator.pop(context);}
                                                noticeCon.getNoticeList();
                                              },
                                            );
                                          },
                                        );
                                      } else {
                                        Get.to(() => CreateNotice(
                                              isUpdate: true,
                                              noticeid: noticeCon
                                                  .noticeList[index].id,
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
}

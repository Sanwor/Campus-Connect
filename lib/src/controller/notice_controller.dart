import 'dart:developer';
import 'dart:io';
import 'package:campus_connect/src/app_config/api_repo.dart';
import 'package:campus_connect/src/model/noticeDetail_model.dart';
import 'package:campus_connect/src/model/notice_model.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class NoticeController extends GetxController {
  RxBool isNoticeLoading = false.obs;
  RxBool isNoticeDetailsLoading = false.obs;
  RxBool isNoticePostLoading = false.obs;
  RxBool isNoticeDeleting = false.obs;
  RxBool isNoticePatchLoading = false.obs;
  RxList noticeList = [].obs;
  dynamic noticeDetails;

  getNoticeList() async {
    isNoticeLoading.value = true;
    try {
      var response = await ApiRepo.apiGet("notices/", "");
      if (response != null) {
        //status code pathako chaina uta bata
        var listOfData = [];
        for (var data in response) {
          listOfData.add(NoticeModel.fromJson(data));
        }
        noticeList.value = listOfData;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isNoticeLoading.value = false;
    }
  }

  getNoticeDetails(id) async {
    isNoticeDetailsLoading.value = true;
    try {
      var response = await ApiRepo.apiGet("notices/$id/", "");
      if (response != null) {
        var data = NoticeDetailsModel.fromJson(response);
        noticeDetails = data;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isNoticeDetailsLoading.value = false;
    }
  }

  postNotice({
    required String title,
    required String details,
    required File? noticeImage,
  }) async {
    isNoticePostLoading.value = true;
    try {
      Map<String, dynamic> formMap = {
        "title": title,
        "content": details,
      };

      formMap["featured_image"] =
          await MultipartFile.fromFile(noticeImage!.path);

      FormData formData = FormData.fromMap(formMap);

      // API call
      var response = await ApiRepo.apiPost("notices/", formData);

      if (response != null) {
        Get.back();
        showToast("Notice posted successfully!");
        await getNoticeList(); // refresh list
      }
    } catch (e, stack) {
      log("Error posting notice: $e");
      log(stack.toString());
      showToast("Failed to post notice");
    } finally {
      isNoticePostLoading.value = false;
    }
  }

  patchNotice(id, {title, details, noticeImage}) async {
    isNoticePatchLoading.value = true;
    try {
      Map<String, dynamic> formMap = {
        "title": title,
        "content": details,
      };

      if (noticeImage != null) {
        formMap["featured_image"] = await MultipartFile.fromFile(
          noticeImage.path,
        );
      }

      FormData formData = FormData.fromMap(formMap);

      var response = await ApiRepo.apiPatch("notices/$id/", formData);
      if (response != null) {
        Get.back();
        showToast('Notice updated successfully!');
        getNoticeList();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isNoticePatchLoading.value = false;
    }
  }

  deleteNotice(id) async {
    try {
      // start loading
      isNoticeDetailsLoading.value = true;

      // call DELETE endpoint
      var response = await ApiRepo.apiDelete("notices/$id/", "");

      if (response != null) {
        // success case – you can show a toast or remove from list
        showToast("Notice with id $id deleted successfully");
        log("Notice with id $id deleted successfully");

        // Optionally: refresh notice list
        await getNoticeList();
      }
    } catch (e) {
      log("Error deleting notice: ${e.toString()}");
    } finally {
      isNoticeDetailsLoading.value = false;
    }
  }
}

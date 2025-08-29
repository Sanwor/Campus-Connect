import 'dart:developer';
import 'package:campus_connect/src/app_config/api_repo.dart';
import 'package:campus_connect/src/model/noticeDetail_model.dart';
import 'package:campus_connect/src/model/notice_model.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

class NoticeController extends GetxController {
  RxBool isNoticeLoading = false.obs;
  RxBool isNoticeDetailsLoading = false.obs;
  RxBool isNoticePostLoading = false.obs;
  RxList noticeList = [].obs;
  dynamic noticeDetails;

  getNoticeList() async {
    isNoticeLoading.value = true;
    try {
      var response = await ApiRepo.apiGet("notices/", "");
      if (response != null) { //status code pathako chaina uta bata
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
      var response = await ApiRepo.apiGet("/notices/$id", "");
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

  // postProject(
  //     {clientId,
  //     companyId,
  //     type,
  //     title,
  //     details,
  //     address,
  //     province,
  //     zone,
  //     municipal,
  //     latitude,
  //     longitude,
  //     landArea,
  //     floorArea,
  //     startDate,
  //     plannedCompleteDate,
  //     endDate,
  //     estimatedCost,
  //     actualCost,
  //     status,
  //     active,
  //     document}) async {
  //   isNoticePostLoading.value = true;
  //   try {
  //     var finalDoc = [];
  //     for (var data in document) {
  //       finalDoc.add({
  //         "doc_type":
  //             (data["doc_type"] as TextEditingController).text.toString(),
  //         "doc_title":
  //             (data["doc_title"] as TextEditingController).text.toString(),
  //         "file_name": await MultipartFile.fromFile(data["file_name"].path),
  //       });
  //     }
  //     Map<String, dynamic> formMap = {
  //       "client_id": clientId,
  //       "company_id": companyId,
  //       "type": type,
  //       "title": title,
  //       "detail": details,
  //       "address": address,
  //       "province": province,
  //       "zone": zone,
  //       "municipal": municipal,
  //       "latitude": latitude,
  //       "longitude": longitude,
  //       "land_area": landArea,
  //       "floor_area": floorArea,
  //       "started_date": startDate,
  //       "planned_complete_date": plannedCompleteDate,
  //       "end_date": endDate,
  //       "estimated_cost": estimatedCost,
  //       "actual_cost": actualCost,
  //       "status": status,
  //       "active": active,
  //       "documents": finalDoc
  //     };

  //     FormData formData = FormData.fromMap(formMap);

  //     var response = await ApiRepo.apiPost(
  //         "/appadmin/projects/store-with-document", formData);
  //     if (response != null && response["status"] == "success") {
  //       Get.back();
  //       showToast(response["message"] ?? "");
  //       getProjectList();
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   } finally {
  //     isNoticePostLoading.value = false;
  //   }
  // }
}

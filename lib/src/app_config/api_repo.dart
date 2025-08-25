import 'dart:developer';
import 'package:campus_connect/src/app_config/constant.dart';
import 'package:campus_connect/src/app_config/dio_client.dart';
import 'package:campus_connect/src/widgets/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ApiRepo {
  static apiPost(apiPath, params, [apiName]) async {
    try {
      var response = await dio.post("${getBaseUrl()}$apiPath", data: params);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode != 503) {
          if (e.response!.data['code'] == 423) {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                e.response!.data['errors'].forEach((key, value) {});
              } else {}
            }
          } else {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                e.response!.data['errors'].forEach((key, value) {});
              } else {}
            } else {
              if (e.response!.data['message'] is Map) {
                e.response!.data['message'].forEach((key, value) {});
              } else {
                log(e.response!.data['message']);
                showErrorToast(e.response!.data['message']);
              }
            }
          }
        }

        if (e.response!.statusCode == 422) {
          showErrorToast(e.response!.data['message']);
          return e.response!.data;
        }
      } else {
        return e.response!.data;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static apiGet(apiPath, queryParameters, [apiName, showErrorToast]) async {
    dynamic errMsg = '';
    try {
      var response = await dio.get("${getBaseUrl()}$apiPath",
          queryParameters: queryParameters == '' ? {} : queryParameters);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response;
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 433) {
        if (e.response!.data['errors'] != null) {}
        return 433;
      } else if (e.response != null && e.response!.statusCode == 404) {
        return;
      } else if (showErrorToast == null) {
        if (e.response != null) {
          if (e.response!.statusCode != 503) {
            if (e.response!.data['code'] == 423) {
              if (e.response!.data['errors'] != null) {
                if (e.response!.data['errors'] is Map) {
                  e.response!.data['errors'].forEach((key, value) {
                    return e.response!.data['errors'][key][0];
                  });
                } else {
                  return e.response!.data['message'];
                }
              }
            } else {
              if (e.response!.data['errors'] != null) {
                if (e.response!.data['errors'] is Map) {
                  var inncorrectCodeErr = ""; // Detect incorrect Code
                  e.response!.data['errors'].forEach((key, value) {
                    if (e.response!.data['errors'][key][0] !=
                            "alreadyRegisteredJp".tr &&
                        e.response!.data['errors'][key][0] != "codeUsed".tr) {}
                    if (e.response!.data['errors'][key][0] == "codeUsed".tr) {
                      inncorrectCodeErr = "codeUsed".tr;

                      return;
                    }
                    // If Incorrect Code no need to show pop up
                    if (inncorrectCodeErr != "codeUsed".tr) {
                      errMsg = e.response!.data;
                    }
                  });
                } else {}
              } else {
                if (e.response!.data['message'] is Map) {
                  e.response!.data['message'].forEach((key, value) {});
                } else {}
              }
            }
          }
        } else {}
        if (errMsg != "" && errMsg != null) {
          if (errMsg["errors"]["email"] != null) {
            if (errMsg["errors"]["email"][0] == "alreadyRegisteredJp".tr) {
              return errMsg;
            }
          }
        }
      }
      return;
    } catch (e) {
      log(e.toString());
    }
  }

  static apiPut(apiPath, queryParameters, [apiName]) async {
    try {
      var response = await dio.put(
          apiPath.contains("https://") ? apiPath : "${getBaseUrl()}$apiPath",
          data: queryParameters);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode != 503) {
          if (e.response!.data['code'] == 423) {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                e.response!.data['errors'].forEach((key, value) {});
              } else {}
            }
          } else {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                e.response!.data['errors'].forEach((key, value) {});
              } else {}
            } else {
              if (e.response!.data['message'] is Map) {
                e.response!.data['message'].forEach((key, value) {});
              } else {}
            }
          }
        }
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }

  static apiPatch(apiPath, queryParameters, [apiName]) async {
    dynamic errMsg = '';
    try {
      var response =
          await dio.patch("${getBaseUrl()}$apiPath", data: queryParameters);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return response;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode != 503) {
          if (e.response!.data['code'] == 423) {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                e.response!.data['errors'].forEach((key, value) {
                  return e.response!.data['errors'][key][0];
                });
              } else {
                return e.response!.data['message'];
              }
            }
          } else {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                var inncorrectCodeErr = ""; // Detect incorrect Code
                e.response!.data['errors'].forEach((key, value) {
                  if (e.response!.data['errors'][key][0] !=
                          "alreadyRegisteredJp".tr &&
                      e.response!.data['errors'][key][0] != "codeUsed".tr) {}
                  if (e.response!.data['errors'][key][0] == "codeUsed".tr) {
                    inncorrectCodeErr = "codeUsed".tr;

                    return;
                  }
                  // If Incorrect Code no need to show pop up
                  if (inncorrectCodeErr != "codeUsed".tr) {
                    errMsg = e.response!.data;
                  }
                });
              } else {}
            } else {
              if (e.response!.data['message'] is Map) {
                e.response!.data['message'].forEach((key, value) {});
              } else {}
            }
          }
        }
      } else {}
      if (errMsg != "" && errMsg != null) {
        if (errMsg["errors"]["email"] != null) {
          if (errMsg["errors"]["email"][0] == "alreadyRegisteredJp".tr) {
            return errMsg;
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static apiDelete(apiPath, [apiName]) async {
    try {
      var response = await dio.delete(
          apiPath.contains("https://") ? apiPath : "${getBaseUrl()}$apiPath");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode != 503) {
          if (e.response!.data['code'] == 423) {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                e.response!.data['errors'].forEach((key, value) {});
              } else {}
            }
          } else {
            if (e.response!.data['errors'] != null) {
              if (e.response!.data['errors'] is Map) {
                e.response!.data['errors'].forEach((key, value) {});
              } else {}
            } else {
              if (e.response!.data['message'] is Map) {
                e.response!.data['message'].forEach((key, value) {});
              } else {}
            }
          }
        }
      } else {}
    } catch (e) {
      log(e.toString());
    }
  }
}

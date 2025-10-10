/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

import 'package:dio/dio.dart';

import 'configuration_api_constant.dart';
import 'configuration_interceptor.dart';

class ConfigurationNetwork {
  late Dio request;
  final BaseOptions options = BaseOptions(
    baseUrl: ConfigurationApiConstant.baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 1000),
    validateStatus: (status) {
      return status != null && status < 700;
    },
  );

  ConfigurationNetwork() {
    request = Dio(options);
    request.interceptors.add(ConfigurationInterceptor());
  }
}

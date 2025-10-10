/* 
Created by Neloy on 10 October, 2025.
Email: taufiqneloy.swe@gmail.com
*/

abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class ServerException extends AppException {
  const ServerException(super.message);

  @override
  String toString() {
    return message;
  }
}

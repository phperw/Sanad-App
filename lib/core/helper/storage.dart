

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  Future saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }
  Future<String?> getToken() async {
  return  await storage.read(key: 'token') ?? "";
  }
  Future deleteToken()async{
    await storage.delete(key: 'token');
  }



Future<void> saveUserData(String name, String email) async {
  await storage.write(key: 'user_name', value: name);
  await storage.write(key: 'user_email', value: email);
}
Future<Map<String, String?>> getUserData() async {
  final name = await storage.read(key: 'user_name');
  final email = await storage.read(key: 'user_email');
  return {'name': name, 'email': email};
}
Future<void> deleteUserData() async {
  await storage.delete(key: 'user_name');
  await storage.delete(key: 'user_email');
}

}

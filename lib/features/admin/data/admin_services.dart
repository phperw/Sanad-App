import 'admin_api_client.dart';
import 'admin_repository.dart';
import 'admin_secure_storage.dart';

class AdminServices {
  AdminServices._();

  static final storage = AdminSecureStorage();
  static final repository = AdminRepository(AdminApiClient(storage), storage);
}

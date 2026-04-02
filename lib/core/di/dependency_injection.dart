import 'package:get_it/get_it.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import '../../features/auth/login/data/repo/login_repository.dart';
import '../../features/auth/login/logic/login_cubit.dart';
import '../../features/auth/register/data/repo/register_repository.dart';
import '../../features/auth/register/logic/register_cubit.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton(() => DioFactory.getDio());
  getIt.registerLazySingleton(() => LoginRepository(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerLazySingleton(() => RegisterRepository(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
}

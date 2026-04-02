import 'package:get_it/get_it.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import '../../features/auth/login/data/repo/login_repository.dart';
import '../../features/auth/login/logic/login_cubit.dart';
import '../../features/auth/register/data/repo/register_repository.dart';
import '../../features/auth/register/logic/register_cubit.dart';
import '../../features/home/data/repo/home_repository.dart';
import '../../features/home/logic/home_cubit.dart';
import '../helper/shared_pref_helper.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  await SharedPrefHelper.init();

  getIt.registerLazySingleton(() => DioFactory.getDio());

  // Auth
  getIt.registerLazySingleton(() => LoginRepository(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerLazySingleton(() => RegisterRepository(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));

  // Home
  getIt.registerFactory<HomeRepository>(() => HomeRepository(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));
}

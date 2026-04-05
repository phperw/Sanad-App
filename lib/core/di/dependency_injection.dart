import 'package:get_it/get_it.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import '../../features/account/data/api service/account_api_service.dart';
import '../../features/account/data/repo/account_repository.dart';
import '../../features/account/data/repo/get_users_card/account_repository.dart'
    as card;
import '../../features/account/logic/account_cubit.dart';
import '../../features/account/logic/get_user_card/account_cubit.dart';
import '../../features/auth/login/data/repo/login_repository.dart';
import '../../features/auth/login/logic/login_cubit.dart';
import '../../features/auth/register/data/repo/register_repository.dart';
import '../../features/auth/register/logic/register_cubit.dart';
import '../../features/chats_and_community/data/api_service/post_api_service.dart';
import '../../features/chats_and_community/data/repo/post_repository.dart';
import '../../features/chats_and_community/logic/community/community_feed_cubit.dart';
import '../../features/chats_and_community/logic/create_post_cubit.dart';
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

  // Account
  getIt.registerLazySingleton(() => AccountApiService(getIt()));
  getIt.registerLazySingleton(() => AccountRepository(getIt()));
  getIt.registerFactory(() => AccountCubit(getIt()));
  getIt.registerLazySingleton(() => card.AccountRepository(getIt()));
  getIt.registerFactory(() => AccountCubitCard(getIt()));

  // Community
  getIt.registerLazySingleton(() => PostApiService(getIt()));
  getIt.registerLazySingleton(() => PostRepository(getIt()));
  getIt.registerFactory(() => CreatePostCubit(getIt()));
  getIt.registerFactory(() => CommunityFeedCubit(getIt()));
}

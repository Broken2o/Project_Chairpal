import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit/signup_cubit.dart';
import '../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../features/auth/presentation/cubit/verification_cubit/verification_cubit.dart';
import '../../features/auth/data/datasources/medical_conditions_remote_data_source.dart';
import '../../features/auth/data/datasources/medical_conditions_remote_data_source_impl.dart';
import '../../features/auth/data/repositories/medical_conditions_repository_impl.dart';
import '../../features/auth/domain/repositories/medical_conditions_repository.dart';
import '../../features/auth/domain/usecases/get_medical_conditions_usecase.dart';
import '../../features/auth/presentation/cubit/medical_conditions_cubit/medical_conditions_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_user_dashboard_usecase.dart';
import '../../features/home/presentation/cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../../features/home/presentation/cubit/category_cubit/category_cubit.dart';
import '../../features/home/presentation/cubit/popular_places_cubit/popular_places_cubit.dart';
import '../../features/home/presentation/cubit/last_visited_places_cubit/last_visited_places_cubit.dart';
import '../../features/home/domain/usecases/create_category_use_case.dart';
import '../../features/home/domain/usecases/update_category_use_case.dart';
import '../../features/home/domain/usecases/delete_category_use_case.dart';
import '../../features/home/presentation/cubit/add_category_cubit/add_category_cubit.dart';
import '../../features/home/presentation/cubit/category_details_cubit/category_details_cubit.dart';
import '../../features/home/domain/usecases/get_wheelchair_health_usecase.dart';
import '../../features/home/domain/usecases/get_wheelchair_sensor_readings_usecase.dart';
import '../../features/home/presentation/cubit/patient_details_cubit/patient_details_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../../features/chatbot/data/services/chatbot_api_service.dart';
import '../../features/home/domain/usecases/add_organization_usecase.dart';
import '../../features/home/presentation/cubit/add_organization_cubit/add_organization_cubit.dart';

import '../../features/home/domain/usecases/get_buildings_usecase.dart';
import '../../features/home/domain/usecases/create_building_usecase.dart';
import '../../features/home/presentation/cubit/building_list_cubit/building_list_cubit.dart';
import '../../features/home/presentation/cubit/add_building_cubit/add_building_cubit.dart';

import '../../features/home/domain/usecases/get_floors_usecase.dart';
import '../../features/home/domain/usecases/create_floor_usecase.dart';
import '../../features/home/presentation/cubit/floor_list_cubit/floor_list_cubit.dart';
import '../../features/home/presentation/cubit/add_floor_cubit/add_floor_cubit.dart';

import '../../features/home/domain/usecases/get_places_by_floor_usecase.dart';
import '../../features/home/domain/usecases/create_place_in_floor_usecase.dart';
import '../../features/home/presentation/cubit/place_list_cubit/place_list_cubit.dart';
import '../../features/home/presentation/cubit/add_place_cubit/add_place_cubit.dart';

import '../../features/connections/data/datasources/connections_remote_data_source.dart';
import '../../features/connections/data/repositories/connections_repository_impl.dart';
import '../../features/connections/domain/repositories/connections_repository.dart';
import '../../features/connections/domain/usecases/get_pending_connections_usecase.dart';
import '../../features/connections/domain/usecases/get_connected_companions_usecase.dart';
import '../../features/connections/domain/usecases/get_connected_doctor_usecase.dart';
import '../../features/connections/domain/usecases/handle_connection_usecase.dart';
import '../../features/connections/domain/usecases/remove_connection_usecase.dart';
import '../../features/connections/domain/usecases/send_connection_request_usecase.dart';
import '../../features/connections/presentation/cubit/companion_status_cubit.dart';
import '../../features/connections/presentation/cubit/companions_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_favorites_usecase.dart';
import '../../features/profile/domain/usecases/send_support_message_usecase.dart';
import '../../features/profile/domain/usecases/update_language_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/cubit/favorites_cubit/favorites_cubit.dart';
import '../../features/profile/presentation/cubit/profile_update_cubit.dart';
import '../../features/profile/presentation/cubit/support_cubit/support_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_data_source.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/home/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/home/presentation/cubit/favorite_cubit/favorite_cubit.dart';
import '../../features/home/domain/usecases/get_reviews_usecase.dart';
import '../../features/home/domain/usecases/add_review_usecase.dart';
import '../../features/home/domain/usecases/delete_review_usecase.dart';
import '../../features/home/presentation/cubit/review_cubit/review_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient());

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ChatBotApiService>(
    () => ChatBotApiService(sl()),
  );
  sl.registerLazySingleton<ConnectionsRemoteDataSource>(
    () => ConnectionsRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(dioClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ConnectionsRepository>(
    () => ConnectionsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => ResendVerificationCodeUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetUserDashboardUseCase(sl()));
  sl.registerLazySingleton(() => CreateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  sl.registerLazySingleton(() => GetLocalUserUseCase(sl()));
  sl.registerLazySingleton(() => ClearLocalTokensUseCase(sl()));
  sl.registerLazySingleton(() => GetPendingConnectionsUseCase(sl()));
  sl.registerLazySingleton(() => GetConnectedCompanionsUseCase(sl()));
  sl.registerLazySingleton(() => GetConnectedDoctorUseCase(sl()));
  sl.registerLazySingleton(() => HandleConnectionUseCase(sl()));
  sl.registerLazySingleton(() => RemoveConnectionUseCase(sl()));
  sl.registerLazySingleton(() => SendConnectionRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => SendSupportMessageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLanguageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Cubits
  sl.registerFactory(() => ProfileUpdateCubit(
        updateProfileUseCase: sl(),
        getConnectedDoctorUseCase: sl(),
        removeConnectionUseCase: sl(),
      ));
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
  sl.registerFactory(() => SignupCubit(signupUseCase: sl()));
  sl.registerFactory(() => ForgotPasswordCubit(
        forgotPasswordUseCase: sl(),
        verifyOtpUseCase: sl(),
        resetPasswordUseCase: sl(),
      ));
  sl.registerFactoryParam<VerificationCubit, String, dynamic>(
    (email, _) => VerificationCubit(
      verifyEmailUseCase: sl(),
      resendCodeUseCase: sl(),
      email: email,
    ),
  );
  sl.registerFactory(() => UserCubit(
        getLocalUserUseCase: sl(),
        getProfileUseCase: sl(),
        logoutUseCase: sl(),
        deleteAccountUseCase: sl(),
        clearLocalTokensUseCase: sl(),
      ));
  sl.registerFactory(() => HomeDashboardCubit(getUserDashboardUseCase: sl()));
  sl.registerFactory(() => CategoryCubit(homeRepository: sl()));
  sl.registerFactory(() => PopularPlacesCubit(homeRepository: sl()));
  sl.registerFactory(() => LastVisitedPlacesCubit(homeRepository: sl()));
  sl.registerFactory(() => AddCategoryCubit(createCategoryUseCase: sl()));
  sl.registerFactory(() => CategoryDetailsCubit(repository: sl()));
  sl.registerLazySingleton(() => AddOrganizationUseCase(sl()));
  sl.registerFactory(() => AddOrganizationCubit(addOrganizationUseCase: sl()));
  sl.registerFactory(
    () => CompanionStatusCubit(
      getPendingConnectionsUseCase: sl(),
      getConnectedCompanionsUseCase: sl(),
      sendConnectionRequestUseCase: sl(),
    ),
  );
  sl.registerFactory(() => CompanionsCubit(
        getPendingConnectionsUseCase: sl(),
        getConnectedCompanionsUseCase: sl(),
        handleConnectionUseCase: sl(),
        removeConnectionUseCase: sl(),
      ));
  sl.registerFactory(() => FavoritesCubit(getFavoritesUseCase: sl()));
  sl.registerFactory(() => FavoriteCubit(toggleFavoriteUseCase: sl()));
  sl.registerFactory(() => SupportCubit(sendSupportMessageUseCase: sl()));
  sl.registerFactory(() => NotificationsCubit(
        repository: sl(),
        getPendingConnectionsUseCase: sl(),
      ));

  // Patient Details
  sl.registerLazySingleton(() => GetWheelchairHealthUseCase(sl()));
  sl.registerLazySingleton(() => GetWheelchairSensorReadingsUseCase(sl()));
  sl.registerFactory(() => PatientDetailsCubit(
        getHealthUseCase: sl(),
        getSensorReadingsUseCase: sl(),
      ));

  // Buildings
  sl.registerLazySingleton(() => GetBuildingsUseCase(sl()));
  sl.registerLazySingleton(() => CreateBuildingUseCase(sl()));
  sl.registerFactory(() => BuildingListCubit(getBuildingsUseCase: sl()));
  sl.registerFactory(() => AddBuildingCubit(createBuildingUseCase: sl()));

  // Floors
  sl.registerLazySingleton(() => GetFloorsUseCase(sl()));
  sl.registerLazySingleton(() => CreateFloorUseCase(sl()));
  sl.registerFactory(() => FloorListCubit(getFloorsUseCase: sl()));
  sl.registerFactory(() => AddFloorCubit(createFloorUseCase: sl()));

  // Places
  sl.registerLazySingleton(() => GetPlacesByFloorUseCase(sl()));
  sl.registerLazySingleton(() => CreatePlaceInFloorUseCase(sl()));
  sl.registerFactory(() => PlaceListCubit(getPlacesByFloorUseCase: sl()));
  sl.registerFactory(() => AddPlaceCubit(createPlaceInFloorUseCase: sl()));

  // Reviews
  sl.registerLazySingleton(() => GetReviewsUseCase(sl()));
  sl.registerLazySingleton(() => AddReviewUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReviewUseCase(sl()));
  sl.registerFactory(() => ReviewCubit(
        getReviewsUseCase: sl(),
        addReviewUseCase: sl(),
        deleteReviewUseCase: sl(),
      ));

  // Medical Conditions
  sl.registerLazySingleton<MedicalConditionsRemoteDataSource>(
    () => MedicalConditionsRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );
  sl.registerLazySingleton<MedicalConditionsRepository>(
    () => MedicalConditionsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetMedicalConditionsUseCase(sl()));
  sl.registerFactory(() => MedicalConditionsCubit(getMedicalConditionsUseCase: sl()));
}

import 'package:chair_pal/features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:chair_pal/features/community/domain/repositories/community_repository.dart';
import 'package:chair_pal/features/community/data/repositories/community_repository_impl.dart';
import 'package:chair_pal/features/community/data/datasources/community_remote_data_source.dart';
import 'package:chair_pal/features/community/domain/repositories/friends_repository.dart';
import 'package:chair_pal/features/community/data/repositories/friends_repository_impl.dart';
import 'package:chair_pal/features/community/data/datasources/friends_remote_data_source.dart';
import 'package:chair_pal/features/community/presentation/cubit/friends_cubit.dart';
import 'package:chair_pal/features/chat/domain/repositories/chat_repository.dart';
import 'package:chair_pal/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chair_pal/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:chair_pal/features/chat/presentation/cubit/chats_cubit.dart';
import 'package:chair_pal/features/accessibility/data/repositories/ros_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chair_pal/core/theme/app_colors.dart';
import 'package:chair_pal/core/localization/locale_provider.dart';
import 'package:chair_pal/core/localization/locale_state.dart';
import 'package:chair_pal/core/navigation/navigator_service.dart';
import 'package:chair_pal/core/di/injection_container.dart' as di;

import 'package:chair_pal/l10n/l10n.dart';

import 'features/splash/presentation/cubit/splash_cubit.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'core/widgets/global_sos_listener.dart';
import 'firebase_options.dart';

// areejkamel753@gmail.com
// chairpal@123

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Init Dependency Injection
  await di.init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ChairPalApp());
}

class ChairPalApp extends StatelessWidget {
  const ChairPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CommunityRepository>(
          create: (context) => CommunityRepositoryImpl(
            remoteDataSource: CommunityRemoteDataSourceImpl(),
          ),
        ),
        RepositoryProvider<FriendsRepository>(
          create: (context) => FriendsRepositoryImpl(
            remoteDataSource: FriendsRemoteDataSourceImpl(),
          ),
        ),
        RepositoryProvider<ChatRepository>(
          create: (context) => ChatRepositoryImpl(
            remoteDataSource: ChatRemoteDataSourceImpl(),
          ),
        ),
        RepositoryProvider<AccessibilityRepository>(
          create: (context) => RosRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LocaleProvider()),
          BlocProvider(
            create: (context) => di.sl<UserCubit>()..loadUser(),
          ),
          BlocProvider(
            create: (context) => FriendsCubit(repository: context.read<FriendsRepository>())..fetchFriendsAndRequests(),
          ),
          BlocProvider(
            create: (context) => ChatsCubit(repository: context.read<ChatRepository>())..fetchChats(),
          ),
        ],
        child: BlocBuilder<LocaleProvider, LocaleState>(
          builder: (context, localeState) {
            return ScreenUtilInit(
              designSize: const Size(390, 844),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return GlobalSosListener(
                  child: MaterialApp(
                    navigatorKey: NavigationService.navigatorKey,
                  title: 'ChairPal',
                  debugShowCheckedModeBanner: false,
                  // Localization
                  locale: localeState.locale,
                  supportedLocales: const [
                    Locale('en'),
                    Locale('ar'),
                    Locale('fr'),
                    Locale('de'),
                    Locale('hi'),
                    Locale('ko'),
                    Locale('vi'),
                  ],
                  localizationsDelegates: const [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: ThemeData(
                    primaryColor: AppColors.primary,
                    scaffoldBackgroundColor: AppColors.scaffoldBackground,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: AppColors.primary,
                      primary: AppColors.primary,
                      secondary: AppColors.primaryLight,
                    ),
                    useMaterial3: true,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                    ),
                    ),
                    home: child,
                  ),
                );
              },
              child: BlocProvider(
                create: (context) => SplashCubit(),
                child: const SplashScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}

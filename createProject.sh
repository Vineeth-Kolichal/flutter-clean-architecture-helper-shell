
#Change project name and domain
projectName="example_app"
domain="com.sample"

#Excecution begins here
flutter create "$projectName" --org "$domain"
cd "$projectName"


mkdir assets
cd assets
mkdir images
cd images
touch .gitkeep
cd ..
cd ..
rm -rf pubspec.yaml
touch pubspec.yaml
echo "
name: ${projectName}
description: "A new Flutter project."

publish_to: 'none' 

version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons:
  dartz: 
  flutter_bloc: 
  injectable: 
  freezed_annotation: 
  get_it: 
  dio: 

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: 
  freezed: 
  injectable_generator: 

flutter:
  uses-material-design: true

  assets:
    - assets/images/
" > pubspec.yaml

flutter pub get

cd lib
rm -rf main.dart
touch main.dart
echo "import 'dart:async';

import 'package:flutter/material.dart';
import 'app.dart';
import 'core/routes/app_routes.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(
      appRoutes: AppRoutes(),
    ),
  );
}" > main.dart

touch app.dart
echo "import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRoutes});
  final AppRoutes appRoutes;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: const [],
      child: MaterialApp(
        title: 'App title',
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        onGenerateRoute: appRoutes.onGenerateRoute,
      ),
    );
  }
}" > app.dart

mkdir core
cd core

mkdir api_endpoints
cd api_endpoints
touch api_endpoints.dart

echo "class ApiEndpoints {
  static String baseUrl = ' ';
}" >api_endpoints.dart
cd ..

mkdir base_usecase
cd base_usecase
touch usecase.dart
echo "import 'package:dartz/dartz.dart';

import '../failures/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}" >usecase.dart
cd ..

mkdir dependancy_injection
cd dependancy_injection
mkdir config
cd config
touch configure_injection.dart
echo "
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'configure_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async {
  getIt.init(environment: Environment.prod);
}" > configure_injection.dart
cd ..

mkdir modules
cd modules
touch dio_module.dart
echo "import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../api_endpoints/api_endpoints.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio get dioInstance => Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
}" > dio_module.dart
cd ..
cd ..

mkdir failures
cd failures
touch failures.dart
echo "import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
class Failure with _\$Failure {
  factory Failure.apiRequestFailure(String error) = ApiRequestFailure;
}" > failures.dart
cd ..

mkdir network_exceptions
cd network_exceptions
touch network_exceptions.dart
echo "import 'package:dio/dio.dart';

class CustomException implements Exception {
  CustomException.otherException(String msg) {
    message = msg;
  }
  CustomException.fromDioError(DioException dioError) {
    if (message == null) {
      switch (dioError.type) {
        case DioException.requestCancelled:
          message = 'Request to API server was cancelled';
          break;
        case DioException.connectionTimeout:
          message = 'Connection timeout with API server';
          break;
        case DioException.connectionError:
          message =
              'Connection to API server failed due to internet connection';
          break;
        case DioException.receiveTimeout:
          message = 'Receive timeout in connection with API server';
          break;
        case DioException.badResponse:
          message = _handleError(dioError.response!.statusCode);
          break;
        case DioException.sendTimeout:
          message = 'Send timeout in connection with API server';
          break;
        default:
          message = _handleDefaultError(dioError);
          break;
      }
    }
  }

  dynamic message;

  String? _handleDefaultError(DioException error) {
    try {
      final response = error.response?.data as Map?;
      if (response != null) {
        return '${response['message']}';
      }
      return error.message;
    } catch (_) {
      return error.message;
    }
  }

  Object _handleError(statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized request';
      case 404:
        return 'The requested resource was not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }

  @override
  String toString() => message.toString();
}" > network_exceptions.dart
cd ..

mkdir routes
cd routes
touch app_routes.dart
echo "import 'package:flutter/material.dart';

class AppRoutes {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // case '/':
      //   return MaterialPageRoute(builder: (ctx) => const SplashScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (ctx) {
      return const Scaffold(
        body: Center(
          child: Text('Something Error'),
        ),
      );
    });
  }
}" > app_routes.dart
cd ..

mkdir theme
cd theme
touch colors.dart
echo "import 'package:flutter/material.dart';

class AppColors {
  static const blackColor = Colors.black;
  static const whiteColor = Colors.white;
}" > colors.dart

touch theme.dart
echo "import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: getTextTheme(isDark: false),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    textTheme: getTextTheme(isDark: true),
  );
}

TextTheme getTextTheme({required bool isDark}) {
  TextTheme lightTextTheme = const TextTheme();
  TextTheme darkTextTheme = const TextTheme();

  if (isDark) {
    return darkTextTheme;
  } else {
    return lightTextTheme;
  }
}" > theme.dart
cd ..
cd ..
mkdir common
cd common
mkdir widgets
cd widgets
touch space.dart
echo "import 'package:flutter/material.dart';

class Space {
  static SizedBox x(double width) => SizedBox(
        width: width,
      );
  static SizedBox y(double height) => SizedBox(
        height: height,
      );
}" > space.dart
cd ..
cd ..
mkdir features
cd features
touch .gitkeep
cd ..
cd ..
cd test
rm -rf widget_test.dart
touch .gitkeep
cd ..
cd ..
cp createFeature.sh "${projectName}/"
cd "${projectName}"
git init
git checkout -b dev


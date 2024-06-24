import 'package:chattin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:chattin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chattin/features/auth/domain/repositories/auth_repository.dart';
import 'package:chattin/features/auth/domain/usecases/sign_in_with_phone.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

//register feature wise
Future<void> initDependencies() async {
  //register the firebase auth
  final firebaseAuthInstance = FirebaseAuth.instance;
  serviceLocator.registerLazySingleton(() => firebaseAuthInstance);
  initAuth();
}

void initAuth() {
  serviceLocator
    ..registerFactory(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSourceImpl: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SendOtpOnPhoneUseCase>(
      () => SendOtpOnPhoneUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        serviceLocator(),
      ),
    );
}

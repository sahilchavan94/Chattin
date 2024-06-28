import 'package:chattin/core/common/features/upload/data/datasource/upload_remote_datasource.dart';
import 'package:chattin/core/common/features/upload/data/repositories/upload_repository_impl.dart';
import 'package:chattin/core/common/features/upload/domain/repositories/upload_repository.dart';
import 'package:chattin/core/common/features/upload/domain/usecases/general_upload.dart';
import 'package:chattin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:chattin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chattin/features/auth/domain/repositories/auth_repository.dart';
import 'package:chattin/features/auth/domain/usecases/check_account_details.dart';
import 'package:chattin/features/auth/domain/usecases/check_status.dart';
import 'package:chattin/features/auth/domain/usecases/email_auth.dart';
import 'package:chattin/features/auth/domain/usecases/email_verification.dart';
import 'package:chattin/features/auth/domain/usecases/set_account_details.dart';
import 'package:chattin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

//register feature wise
Future<void> initDependencies() async {
  //register the firebase auth
  final firebaseAuthInstance = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;
  serviceLocator.registerLazySingleton(() => firebaseAuthInstance);
  serviceLocator.registerLazySingleton(() => firestoreInstance);
  serviceLocator.registerLazySingleton(() => firebaseStorage);

  //general uploads
  serviceLocator.registerLazySingleton(
    () => UploadRemoteDataSourceImpl(
      firebaseStorage: firebaseStorage,
    ),
  );
  serviceLocator.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(
      uploadRemoteDataSourceImpl: serviceLocator(),
    ),
  );
  initAuth();
}

void initAuth() {
  serviceLocator
    ..registerFactory(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: serviceLocator(),
        firebaseFirestore: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSourceImpl: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CreateAccountWithEmailAndPasswordUseCase>(
      () => CreateAccountWithEmailAndPasswordUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SendEmailVerificationLinkUseCase>(
      () => SendEmailVerificationLinkUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CheckVerificationStatusUseCase>(
      () => CheckVerificationStatusUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<SetAccountDetailsUseCase>(
      () => SetAccountDetailsUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CheckTheAccountDetailsIfTheEmailIsVerifiedUseCase>(
      () => CheckTheAccountDetailsIfTheEmailIsVerifiedUseCase(
        authRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GeneralUploadUseCase>(
      () => GeneralUploadUseCase(
        uploadRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
}

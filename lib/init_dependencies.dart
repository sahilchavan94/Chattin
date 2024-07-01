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
import 'package:chattin/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:chattin/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chattin/features/chat/domain/repositories/chat_repository.dart';
import 'package:chattin/features/chat/domain/usecases/get_app_contacts.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_contacts.dart';
import 'package:chattin/features/chat/domain/usecases/get_chat_stream.dart';
import 'package:chattin/features/chat/domain/usecases/send_message.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/cubit/chat_cubit.dart';
import 'package:chattin/features/chat/presentation/cubits/contacts_cubit/contacts_cubit.dart';
import 'package:chattin/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:chattin/features/profile/data/repsotories/profile_repositoy_impl.dart';
import 'package:chattin/features/profile/domain/repositories/profile_repository.dart';
import 'package:chattin/features/profile/domain/usecases/get_profile.dart';
import 'package:chattin/features/profile/presentation/cubit/profile_cubit.dart';
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
  initContacts();
  initProfile();
  initChat();
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

void initContacts() {
  serviceLocator
    ..registerFactory(
      () => ChatRemoteDataSourceImpl(
        firebaseFirestore: serviceLocator(),
      ),
    )
    ..registerFactory<ChatRepository>(
      () => ChatRepositoryImpl(
        chatRemoteDataSourceImpl: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetContactsUseCase>(
      () => GetContactsUseCase(
        chatRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<ContactsCubit>(
      () => ContactsCubit(
        serviceLocator(),
      ),
    );
}

void initChat() {
  serviceLocator
    ..registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(
        chatRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetChatStreamUseCase>(
      () => GetChatStreamUseCase(
        chatRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetChatContactsUseCase>(
      () => GetChatContactsUseCase(
        chatRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ChatCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
}

void initProfile() {
  serviceLocator
    ..registerFactory(
      () => ProfileRemoteDataSourceImpl(
        firebaseFirestore: serviceLocator(),
      ),
    )
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(
        profileRemoteDataSourceImpl: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetProfileDataUseCase>(
      () => GetProfileDataUseCase(
        profileRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ProfileCubit(
        serviceLocator(),
        serviceLocator(),
      ),
    );
}

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:huicrochet_mobile/config/error_state.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/modules/auth/datasource/user_auth_remote_data_source.dart';
import 'package:huicrochet_mobile/modules/auth/repositories/user_auth_repository.dart';
import 'package:huicrochet_mobile/modules/auth/use_cases/login_use_case.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment_byId.dart';
import 'package:huicrochet_mobile/modules/product/datasource/product_remote_data_source.dart';
import 'package:huicrochet_mobile/modules/product/repositories/product_repository.dart';
import 'package:huicrochet_mobile/modules/product/use_cases/fetch_products_data.dart';
import 'package:huicrochet_mobile/modules/payment-methods/datasource/payment_method_data_source.dart';
import 'package:huicrochet_mobile/modules/payment-methods/repositories/payment_method_repository.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/create_payment.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/delete_payment.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/get_payment.dart';
import 'package:huicrochet_mobile/modules/payment-methods/use_cases/update_payment.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Dio Client
  getIt.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: 'http://${ip}:8080/api-crochet')));

  // ErrorState
  getIt.registerSingleton<ErrorState>(ErrorState());

  // User Authentication
  getIt.registerFactory<UserAuthRemoteDataSource>(
      () => UserRemoteDataSourceImpl(dioClient: getIt()));
  getIt.registerFactory<UserAuthRepository>(
      () => UserRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerFactory<LoginUseCase>(
      () => LoginUseCase(userRepository: getIt()));

  // Product
  getIt.registerFactory<ProductRemoteDataSourceImpl>(
      () => ProductRemoteDataSourceImpl(dioClient: getIt()));
  getIt.registerFactory<ProductRepositoryImpl>(
      () => ProductRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerFactory<FetchProductsData>(
      () => FetchProductsData(repository: getIt()));

  // Payment Methods
  getIt.registerFactory<PaymentMethodRemoteDataSource>(
      () => PaymentMethodRemoteDataSourceImpl(dioClient: getIt()));
  getIt.registerFactory<PaymentMethodRepository>(
      () => PaymentMethodRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerFactory<GetPayment>(() => GetPayment(repository: getIt()));
  getIt
      .registerFactory<CreatePayment>(() => CreatePayment(repository: getIt()));
  getIt
      .registerFactory<UpdatePayment>(() => UpdatePayment(repository: getIt()));
  getIt
      .registerFactory<DeletePayment>(() => DeletePayment(repository: getIt()));
  getIt.registerFactory<GetPaymentByid>(
      () => GetPaymentByid(repository: getIt()));
}

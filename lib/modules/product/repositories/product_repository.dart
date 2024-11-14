import 'package:huicrochet_mobile/modules/product/datasource/product_remote_data_source.dart';
import 'package:huicrochet_mobile/modules/product/entities/product_category.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchData();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> fetchData() async {
    final result = await remoteDataSource.fetchData();
    return result;
  }
}

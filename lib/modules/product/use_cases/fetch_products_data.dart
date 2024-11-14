
import 'package:huicrochet_mobile/modules/product/entities/product_category.dart';
import 'package:huicrochet_mobile/modules/product/repositories/product_repository.dart';

class FetchProductsData {
  final ProductRepository repository;

  FetchProductsData({required this.repository});

  Future<List<Product>> execute()async {
    final result = await repository.fetchData();

    return result;
  }
}

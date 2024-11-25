import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/product/user_comment.dart';
import 'package:shimmer/shimmer.dart';

class ProductReviews extends StatefulWidget {
  final String productId;

  const ProductReviews({required this.productId, Key? key}) : super(key: key);

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    final dioClient = DioClient(context);
    final endpoint = "/review/product/${widget.productId}";

    try {
      final response = await dioClient.dio.get(endpoint);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.toString());
        final List<dynamic> reviewData = jsonData['data'];

        setState(() {
          _reviews = reviewData.map((review) {
            final user = review['user'] ?? {};
            final image = user['image'] ?? {};
            return {
              'id': review['id'],
              'userName': user['fullName'] ?? 'Anónimo',
              'review': review['review'] ?? '',
              'stars': review['stars'] ?? 0,
              'reviewDate': DateTime.fromMillisecondsSinceEpoch(
                  review['reviewDate'] ?? 0),
              'userImageUri': image.isNotEmpty
                  ? 'http://$ip:8080/${image['imageUri'].split('/').last}'
                  : null,
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        print('Error al obtener las reseñas: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error desconocido al obtener las reseñas: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentarios (${_reviews.length})',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (_isLoading)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 165,
                height: 170,
                color: Colors.grey[300],
              ),
            ),
          )
        else if (_reviews.isEmpty)
          const Row(children: [
            Text('No hay comentarios disponibles.'),
          ])
        else
          ..._reviews.map((review) {
            return CommentWidget(
              username: review['userName'] ?? 'Anónimo',
              date:
                  '${review['reviewDate']?.day ?? ''}/${review['reviewDate']?.month ?? ''}/${review['reviewDate']?.year ?? ''}',
              description: review['review'] ?? '',
              rating: (review['stars'] as int).toDouble(),
            );
          }).toList(),
      ],
    );
  }
}

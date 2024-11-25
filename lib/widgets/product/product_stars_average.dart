import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:shimmer/shimmer.dart';

class StarAverage extends StatefulWidget {
  final String productId;

  const StarAverage({required this.productId, Key? key}) : super(key: key);

  @override
  _StarAverageState createState() => _StarAverageState();
}

class _StarAverageState extends State<StarAverage> {
  double? _averageStars;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStarAverage();
  }

  Future<void> _fetchStarAverage() async {
    final dioClient = DioClient(context);
    final endpoint = "/review/averageRating/${widget.productId}";

    try {
      final response = await dioClient.dio.get(endpoint);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.toString());
        final averageStars = jsonData['data'];

        setState(() {
          _averageStars = averageStars != null ? averageStars.toDouble() : 0.0;
          _isLoading = false;
        });
      } else {
        print(
            'Error al obtener el promedio de estrellas: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(
          'Error desconocido al obtener el promedio de estrellas: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? ClipRRect(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 60,
                height: 20,
                color: Colors.grey[300],
              ),
            ),
          )
        : Row(
            children: [
              if (_averageStars != null) ...[
                Text(
                  _averageStars!.toStringAsFixed(1),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              ],
            ],
          );
  }
}

import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:huicrochet_mobile/widgets/general/general_button.dart';
import 'package:huicrochet_mobile/widgets/general/loader.dart';

class AddProductReview extends StatefulWidget {
  final String idItem;
  final String idUsuario;

  const AddProductReview({
    Key? key,
    required this.idItem,
    required this.idUsuario,
  }) : super(key: key);

  @override
  State<AddProductReview> createState() => _AddProductReviewState();
}

class _AddProductReviewState extends State<AddProductReview> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  final _loaderController = LoaderController();

  Future<void> _submitReview(BuildContext context) async {
    try {
      final dioClient = DioClient(context);

      final requestBody = {
        "productId": widget.idItem,
        "customerId": widget.idUsuario,
        "review": _commentController.text,
        "stars": _rating,
      };

      final response =
          await dioClient.dio.post('/review/create', data: requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _loaderController.hide();
        Navigator.of(context).pop({
          'status': 'success',
          'data': response.data,
        });
      } else {
        _loaderController.hide();
        Navigator.of(context).pop();
        throw Exception("Error al enviar la reseña");
      }
    } catch (e) {
      _loaderController.hide();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning, 
                color: Colors.white, 
              ),
              SizedBox(width: 8), 
              Text(
                "Ya has comentado este producto",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: colors['wine'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Agregar Reseña",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _commentController,
                    maxLines: 4,
                    cursorColor: colors['pink'],
                    decoration: InputDecoration(
                      hintText: "Escribe tu comentario",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: colors['pink']!,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  GeneralButton(
                    text: 'Enviar',
                    onPressed: () {
                      _loaderController.show(context);
                      if (_rating == 0 || _commentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Por favor completa todos los campos",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: colors['violet'],
                          ),
                        );

                        _loaderController.hide();
                      } else {
                        _submitReview(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

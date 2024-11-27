import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(15.0), 
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Agregar Reseña",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                cursorColor: colors['pink'], // Cambia el color del cursor
                decoration: InputDecoration(
                  hintText: "Escribe tu comentario",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey, // Color del borde cuando no está enfocado
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: colors['pink']!, // Color del borde cuando está enfocado
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    
                      backgroundColor: colors['gray'],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancelar',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      
                      backgroundColor: colors['violet'],
                    ),
                    onPressed: () {
                      final String comment = _commentController.text;
                      print("ID Item: ${widget.idItem}");
                      print("ID Usuario: ${widget.idUsuario}");
                      print("Rating: $_rating");
                      print("Comentario: $comment");
                      Navigator.of(context).pop({
                        'idItem': widget.idItem,
                        'idUsuario': widget.idUsuario,
                        'rating': _rating,
                        'comment': comment,
                      });
                    },
                    child: Text(
                      'Enviar',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

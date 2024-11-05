import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatefulWidget {
  const Loader({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(103, 0, 0, 0),
      body: Center(child: Lottie.asset('assets/loader.json')),
    );
  }
}

class LoaderController {
  OverlayEntry? _overlayEntry;

  void show(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (_) => const Loader(),
      );
      Overlay.of(context)?.insert(_overlayEntry!);
    }
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

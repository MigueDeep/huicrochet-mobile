import 'package:flutter/material.dart';

class PurchaseProgressBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentStep;

  const PurchaseProgressBar({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    Color activeColor = const Color.fromRGBO(242, 148, 165, 1);
    Color activeColorBrown = const Color.fromRGBO(64, 47, 47, 1);
    Color inactiveColor = const Color.fromARGB(63, 142, 119, 119);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.shopping_cart,
                   color: currentStep == '1' || currentStep == '2' || currentStep == '3' ? activeColor : inactiveColor,
                    size: 30,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: currentStep == '1' || currentStep=='2' || currentStep == '3' ? activeColorBrown : inactiveColor,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: currentStep == '2' || currentStep == '3' ? activeColor : inactiveColor,
                    size: 30,
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: currentStep == '2' || currentStep == '3' ? activeColorBrown : inactiveColor,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                  Icon(
                    Icons.payment,
                    color: currentStep == '3' ? activeColor : inactiveColor,
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

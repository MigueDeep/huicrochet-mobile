import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomProgressLine extends StatelessWidget {
  final String orderState;
  const CustomProgressLine({super.key, required this.orderState});

  @override
  Widget build(BuildContext context) {
    final states = ['PENDING', 'PROCESSED', 'SHIPPED', 'DELIVERED'];

    final currentIndex = states.indexOf(orderState);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimelineTile(
              context,
              icon: Icons.shopping_cart,
              label: 'Pendiente',
              isActive: currentIndex >= 0,
              isFirst: true,
              isLast: false,
            ),
            _buildTimelineTile(
              context,
              icon: Icons.inventory,
              label: 'Procesado',
              isActive: currentIndex >= 1,
              isFirst: false,
              isLast: false,
            ),
            _buildTimelineTile(
              context,
              icon: Icons.airplanemode_active,
              label: 'Enviado',
              isActive: currentIndex >= 2,
              isFirst: false,
              isLast: false,
            ),
            _buildTimelineTile(
              context,
              icon: Icons.assignment_turned_in,
              label: 'Entregado',
              isActive: currentIndex >= 3,
              isFirst: false,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isFirst,
    required bool isLast,
  }) {
    return Expanded(
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color:
              isActive ? const Color.fromRGBO(242, 148, 165, 1) : Colors.grey,
          thickness: 2,
        ),
        afterLineStyle: LineStyle(
          color:
              isActive ? const Color.fromRGBO(242, 148, 165, 1) : Colors.grey,
          thickness: 2,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(2),
          color:
              isActive ? const Color.fromRGBO(242, 148, 165, 1) : Colors.grey,
          iconStyle: IconStyle(
            iconData: icon,
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        endChild: Container(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: isActive
                  ? const Color.fromRGBO(242, 148, 165, 1)
                  : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

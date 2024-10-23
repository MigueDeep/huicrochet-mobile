import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  const ProgressLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Preparando
        _buildStatus(
          icon: Icons.inventory,
          label: 'Preparando',
          isActive: true,
        ),
        _buildLine(isActive: true),

        // Enviado
        _buildStatus(
          icon: Icons.airplanemode_active,
          label: 'Enviado',
          isActive: true,
        ),
        _buildLine(isActive: true),

        // En proceso de entrega
        _buildStatus(
          icon: Icons.local_shipping,
          label: 'En proceso de entrega',
          isActive: true,
        ),
        _buildLine(isActive: true),

        // Entregado
        _buildStatus(
          icon: Icons.assignment_turned_in,
          label: 'Entregado',
          isActive: true,
        ),
      ],
    );
  }

  Widget _buildStatus({required IconData icon, required String label, required bool isActive}) {
    return Column(
      children: [
        // Circle icon with border
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? Colors.green : Colors.grey,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: isActive ? Colors.green : Colors.grey,
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 30,
      height: 2,
      color: isActive ? Colors.green : Colors.grey,
    );
  }
}

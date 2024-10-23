import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  const ProgressLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Preparando
        _buildStatusWithLine(
          icon: Icons.inventory,
          label: 'Preparando',
          isActive: true,
          showLineAfter: true,
        ),
        // Enviado
        _buildStatusWithLine(
          icon: Icons.airplanemode_active,
          label: 'Enviado',
          isActive: true,
          showLineAfter: true,
        ),
        // Entregado
        _buildStatusWithLine(
          icon: Icons.assignment_turned_in,
          label: 'Entregado',
          isActive: true,
          showLineAfter: false,
        ),
      ],
    );
  }

  Widget _buildStatusWithLine({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool showLineAfter,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row para el icono y la línea
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              // Línea de conexión
              if (showLineAfter)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isActive ? Colors.green : Colors.grey,
                  ),
                ),
            ],
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
      ),
    );
  }
}
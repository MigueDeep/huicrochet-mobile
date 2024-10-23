import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  const ProgressLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStatusWithLine(
            icon: Icons.inventory,
            label: 'Preparando',
            isActive: true,
            isFirst: true,
            isLast: false,
          ),
          _buildStatusWithLine(
            icon: Icons.airplanemode_active,
            label: 'Enviado',
            isActive: true,
            isFirst: false,
            isLast: false,
          ),
          _buildStatusWithLine(
            icon: Icons.assignment_turned_in,
            label: 'Entregado',
            isActive: true,
            isFirst: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusWithLine({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isFirst,
    required bool isLast,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isFirst) Expanded(child: _buildConnectingLine()),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Uso de Baseline para alinear el ícono y el texto
                  Baseline(
                    baseline: 24,
                    baselineType: TextBaseline.alphabetic,
                    child: Container(
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
                  ),
                  const SizedBox(height: 4),
                  Baseline(
                    baseline: 12,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                        color: isActive ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              if (!isLast) Expanded(child: _buildConnectingLine()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectingLine() {
    return Baseline(
      baseline: -18,
      baselineType: TextBaseline.alphabetic,
      child: Container(
        height: 2,
        color: Colors.green,
      ),
    );
  }
}

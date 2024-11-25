import 'package:flutter/material.dart';

class ActionSheet extends StatelessWidget {
  final String title;
  final List<ActionItem> actions;

  const ActionSheet({
    Key? key,
    required this.title,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 246, 246),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          Text(
            'Más opciones',
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: actions.map((action) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        action.label,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Icon(action.icon, color: action.iconColor),
                      ),
                      onTap: action.onTap,
                    ),
                    if (action != actions.last)
                      const Divider(
                        thickness: 1,
                        color: Color.fromARGB(63, 142, 119, 119),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

void showCustomActionSheet(
    BuildContext context, String title, List<ActionItem> actions) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ActionSheet(
        title: title,
        actions: actions,
      );
    },
  );
}

class ActionItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  ActionItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });
}

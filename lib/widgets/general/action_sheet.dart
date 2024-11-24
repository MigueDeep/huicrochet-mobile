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
      height: actions.length * 70.0 + 100,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            title: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: actions.map((action) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(action.icon, color: action.iconColor),
                      title: Text(
                        action.label,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
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
        ],
      ),
    );
  }
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

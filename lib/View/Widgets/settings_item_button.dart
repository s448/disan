import 'package:flutter/material.dart';

class SettingsItemButton extends StatelessWidget {
  const SettingsItemButton({
    super.key,
    required this.title,
    this.leading,
    required this.trailing,
    required this.action,
  });
  final String title;
  final leading;
  final Icon trailing;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          leading: leading,
          title: Text(title),
          trailing: trailing,
        ),
      ),
    );
  }
}

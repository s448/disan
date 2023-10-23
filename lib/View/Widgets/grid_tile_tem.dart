import 'package:flutter/material.dart';

class GridTileItem extends StatelessWidget {
  const GridTileItem({
    super.key,
    required this.name,
    required this.img,
    required this.networking,
  });
  final String name;
  final String img;
  final bool networking;
  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: Container(
        decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        child: Text(
          name.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: networking
            ? Image.network(
                img.toString(),
                fit: BoxFit.cover,
              )
            : Image.asset(
                img.toString(),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

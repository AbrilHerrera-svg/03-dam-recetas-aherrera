import 'package:flutter/material.dart';
import 'package:recetas_app/models/resena.dart';

class ResenaTile extends StatelessWidget {
  final Resena resena;

  const ResenaTile({super.key, required this.resena});

  @override
  Widget build(BuildContext context) {
    final fecha =
        '${resena.fecha.day.toString().padLeft(2, '0')}/${resena.fecha.month.toString().padLeft(2, '0')}/${resena.fecha.year}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    resena.autor[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ), // Text
                ), // CircleAvatar
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    resena.autor,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ), // Text
                ), // Expanded
                Text(
                  fecha,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ), // Text
              ],
            ), // Row
            const SizedBox(height: 6),
            Text(resena.comentario),
          ],
        ), // Column
      ), // Padding
    ); // Card
  }
}

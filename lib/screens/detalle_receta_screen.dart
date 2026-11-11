import 'package:flutter/material.dart';
import 'package:recetas_app/models/receta.dart';

class DetalleRecetaScreen extends StatelessWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receta.nombre),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              receta.imagenUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                'assets/images/plato-placeholder.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ), // Image.asset
            ), // Image.network
          ), // ClipRRect
          const SizedBox(height: 16),
          Text(
            receta.nombre,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ), // Text
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _InfoChip(icono: Icons.public, texto: receta.cocina),
              _InfoChip(icono: Icons.bar_chart, texto: receta.dificultad),
              _InfoChip(icono: Icons.timer, texto: "${receta.tiempoTotal} min"),
              _InfoChip(icono: Icons.people, texto: "${receta.porciones} porciones"),
              _InfoChip(icono: Icons.local_fire_department, texto: "${receta.calorias} kcal"),
              _InfoChip(icono: Icons.star, texto: receta.calificacion.toStringAsFixed(1)),
            ],
          ), // Wrap
          const SizedBox(height: 20),
          const Text(
            "Ingredientes",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ), // Text
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingrediente)),
                ],
              ), // Row
            ), // Padding
          ),
          const SizedBox(height: 20),
          const Text(
            "Preparación",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ), // Text
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    child: Text(
                      "${entrada.key + 1}",
                      style: const TextStyle(fontSize: 11),
                    ), // Text
                  ), // CircleAvatar
                  const SizedBox(width: 10),
                  Expanded(child: Text(entrada.value)),
                ],
              ), // Row
            ), // Padding
          ),
        ],
      ), // ListView
    ); // Scaffold
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _InfoChip({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icono, size: 16),
      label: Text(texto, style: const TextStyle(fontSize: 12)),
    ); // Chip
  }
}
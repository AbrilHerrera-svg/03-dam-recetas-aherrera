import 'package:flutter/material.dart';
import 'package:recetas_app/data/resenas_db.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/models/resena.dart';
import 'package:recetas_app/widgets/resena_tile.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  List<Resena> _resenas = [];
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  int _calificacionSeleccionada = 0;

  @override
  void initState() {
    super.initState();
    _cargarResenas();
  }

  // lee de la bd las reseñas de esta receta
  Future<void> _cargarResenas() async {
    final resenas = await ResenasDb.instancia.obtenerPorReceta(widget.receta.id);
    if (!mounted) return;
    setState(() => _resenas = resenas);
  }

  @override //Abril Andrea Herrera Dominguez
  void dispose() { 
    _autorController.dispose();
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _agregarResena() async {
    final autor = _autorController.text.trim();
    final comentario = _comentarioController.text.trim();

    if (autor.isEmpty || comentario.isEmpty || _calificacionSeleccionada == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa tu nombre, comentario y calificación"),
        ),
      );
      return;
    }

    // guarda la reseña en la bd
    await ResenasDb.instancia.insert(
      Resena(
        recetaId: widget.receta.id,
        autor: autor,
        comentario: comentario,
        calificacion: _calificacionSeleccionada,
        fecha: DateTime.now(),
      ),
    );

    if (!mounted) return;
    setState(() {
      _autorController.clear();
      _comentarioController.clear();
      _calificacionSeleccionada = 0;
    });
    FocusScope.of(context).unfocus();

    await _cargarResenas();
  }

  Widget _construirFormularioResena() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tu calificación:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              children: List.generate(
                5,
                (indice) => IconButton(
                  onPressed: () =>
                      setState(() => _calificacionSeleccionada = indice + 1),
                  icon: Icon(
                    indice < _calificacionSeleccionada
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _autorController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Tu nombre",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _comentarioController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: "Escribe tu reseña",
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _agregarResena,
                icon: const Icon(Icons.send),
                label: const Text("Publicar reseña"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de la receta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/plato-placeholder.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text(receta.dificultad)),
              Chip(label: Text(receta.cocina)),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                const Icon(Icons.circle, size:6, color: Colors.orange,),
                const SizedBox(height: 8,),
                Expanded(child: Text(ingrediente))
              ],
            ),)
          ),
          const SizedBox(height: 20,),
          const Text("Preparación: ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
          const SizedBox(height: 8,),
          ...receta.instrucciones.asMap().entries.map(
            (entrada)=>Padding(padding: const EdgeInsetsGeometry.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start ,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    '${entrada.key+1}',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(child: Text(entrada.value))
              ],
            ),)
          ),
          const SizedBox(height: 20),
          Text(
            "Reseñas (${_resenas.length}): ",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _construirFormularioResena(),
          const SizedBox(height: 8),
          if (_resenas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Aún no hay reseñas. ¡Sé el primero en opinar!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          else
            ..._resenas.map((resena) => ResenaTile(resena: resena)),
        ],
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final booksRef = FirebaseFirestore.instance.collection('libros');

    return Scaffold(
      appBar: AppBar(
        title: const Text('BiblioStore 📚'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: booksRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final books = snapshot.data!.docs;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(book['prestados']?['titulo'] ?? 'Sin título'),
                  subtitle: Text('Editorial: ${book['editorial'] ?? 'Desconocida'}'),
                  trailing: Text('Existencias: ${book['existencia']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(book: book),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Map<String, dynamic> book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final prestamo = book['prestados'];

    return Scaffold(
      appBar: AppBar(title: Text(book['prestados']?['titulo'] ?? 'Detalle del libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📘 Título: ${prestamo?['titulo'] ?? 'Sin título'}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("👤 Prestado a: ${prestamo?['nombre'] ?? 'Nadie'} ${prestamo?['apellido'] ?? ''}"),
            Text("🎓 Carrera: ${prestamo?['carrera'] ?? '-'}"),
            Text("🕒 Fecha solicitud: ${prestamo?['fecha_solicitud'] ?? '-'}"),
            const SizedBox(height: 20),
            Text("📦 Existencias: ${book['existencia']}"),
            Text("🏢 Editorial: ${book['editorial']}"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.subscriptions),
                label: const Text("Ver Suscriptores"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SubscriptionsPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subsRef = FirebaseFirestore.instance.collection('suscripciones');

    return Scaffold(
      appBar: AppBar(title: const Text("Suscriptores")),
      body: StreamBuilder<QuerySnapshot>(
        stream: subsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final subs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: subs.length,
            itemBuilder: (context, index) {
              var s = subs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text("${s['nombre']} ${s['apellido']}"),
                subtitle: Text("🎓 ${s['carrera']}  •  🆔 ${s['codigo']}"),
              );
            },
          );
        },
      ),
    );
  }
}

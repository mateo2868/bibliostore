import 'package:flutter/material.dart';

void main() {
  runApp(const BiblioStoreApp());
}

class BiblioStoreApp extends StatelessWidget {
  const BiblioStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiblioStore 📚',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BooksScreen(),
    );
  }
}

// Modelo de libro
class Book {
  final String titulo;
  final String editorial;
  final String isbn;
  final int existencia;
  final String? prestadoA;

  Book({
    required this.titulo,
    required this.editorial,
    required this.isbn,
    required this.existencia,
    this.prestadoA,
  });
}

// Lista de libros quemados (mock)
final List<Book> books = [
  Book(
    titulo: 'Aprendiendo PHP',
    editorial: 'Mateo',
    isbn: '123456',
    existencia: 5,
    prestadoA: 'Mateo Arango',
  ),
  Book(
    titulo: 'Flutter para principiantes',
    editorial: 'OpenAI Press',
    isbn: '789101',
    existencia: 3,
  ),
  Book(
    titulo: 'Clean Code',
    editorial: 'Prentice Hall',
    isbn: '112233',
    existencia: 2,
    prestadoA: 'Juan Pérez',
  ),
  Book(
    titulo: 'Patrones de Diseño',
    editorial: 'TechEd',
    isbn: '445566',
    existencia: 10,
  ),
];

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 BiblioStore - Libros'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.deepPurple),
              title: Text(
                book.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Editorial: ${book.editorial}'),
                  Text('ISBN: ${book.isbn}'),
                  Text('Existencias: ${book.existencia}'),
                  if (book.prestadoA != null)
                    Text(
                      'Prestado a: ${book.prestadoA}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                ],
              ),
              trailing: Icon(
                book.prestadoA != null ? Icons.lock : Icons.check_circle,
                color: book.prestadoA != null ? Colors.redAccent : Colors.green,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Agregar libro próximamente...')),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}

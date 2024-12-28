import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'info.dart';

import 'package:project_2/book.dart';
void main() {
  runApp(const Bookshop());
}

class Bookshop extends StatelessWidget {
  const Bookshop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('H&K Bookshop'),
          backgroundColor: Colors.amberAccent,
        ),
        body: const Center(
          child: Books(),
        ),
      ),
    );
  }
}

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  List books = [];

  @override
  void initState(){
    super.initState();
    loadBooks();
  }

  void loadBooks() async {
    const url = 'http://localhost/connect.php';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = json.decode(response.body);

      setState(() {
        books = data.map((obj){
          String bookTitle = obj['title'].toString();
          String bookAuthor = obj['author'].toString();
          double bookPrice = double.parse(obj['price'].toString());
          int bookQuantity = int.parse(obj['quantity'].toString());
          String bookIMG = obj['img'].toString();
          String bookGenre = obj['genre'].toString();
          String bookDescription = obj['description'].toString();
          return Book(
            title: bookTitle, 
            author: bookAuthor, 
            price: bookPrice, 
            quantity: bookQuantity, 
            img: bookIMG,
            genre: bookGenre,
            description: bookDescription,
          );
        }).toList();
      });   
    }
    
  }

  void searchBooks(name) async {
    String url = 'http://localhost/search.php?name=$name';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = json.decode(response.body);

      setState(() {
        books = data.map((obj){
          String bookTitle = obj['title'].toString();
          String bookAuthor = obj['author'].toString();
          double bookPrice = double.parse(obj['price'].toString());
          int bookQuantity = int.parse(obj['quantity'].toString());
          String bookIMG = obj['img'].toString();
          String bookGenre = obj['genre'].toString();
          String bookDescription = obj['description'].toString();
          return Book(
            title: bookTitle, 
            author: bookAuthor, 
            price: bookPrice, 
            quantity: bookQuantity, 
            img: bookIMG,
            genre: bookGenre,
            description: bookDescription,
          );
        }).toList();
      });   
    }   
  }

  @override
  Widget build(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (name) {
            searchBooks(name);
          },
          decoration: InputDecoration(
            labelText: 'Search Books',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        books[index].img.isNotEmpty
                            ? books[index].img
                            : 'https://via.placeholder.com/150',
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 50,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books[index].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Author: ${books[index].author}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Price: \$${books[index].price}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Quantity: ${books[index].quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.amberAccent),
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                              title: books[index].title,
                              genre: books[index].genre,
                              description: books[index].description,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
   );
  }
}

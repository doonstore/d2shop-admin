import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final String url;

  const ViewImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Image'),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Hero(
            tag: url,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(url),
            ),
          ),
        ),
      ),
    );
  }
}

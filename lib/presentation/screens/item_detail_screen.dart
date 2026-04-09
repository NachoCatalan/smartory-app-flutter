

import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.product});

  final Map<String,dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de mi producto'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  elevation: 3,
                  shadowColor: Colors.indigo,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                        child: Image.network(
                          product['image'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 1,
                            children: [
                              Text(product['name'], style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900
                              )),
                              Text(product['category'], style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              )),
                              Text(
                                product['description'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic
                                )
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
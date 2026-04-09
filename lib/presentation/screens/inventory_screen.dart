import 'package:flutter/material.dart';
import 'package:smartory_app/presentation/screens/item_detail_screen.dart';

class InventoryScreen extends StatelessWidget {
  InventoryScreen({super.key});

  //Simular productos
  final List<Map<String, dynamic>> items = [
    {
      "id": "1",
      "name": "Arroz",
      "description": "Arroz blanco grano largo",
      "image":
          "https://i5.walmartimages.cl/asr/1ca2bfb5-4443-4596-b669-6598e95c83ce.9f53542988ebf303c48682a5a0e8665e.jpeg",
      "category": "Alimentos",
    },
    {
      "id": "2",
      "name": "Bebida",
      "description": "Bebida gaseosa 1.5L",
      "image":
          "https://clickwine.cl/cdn/shop/products/BlancoAguamarinaPincelPinceladaPersonalLogotipo_12.png?v=1612113455",
      "category": "Bebestibles",
    },
    {
      "id": "3",
      "name": "Pan",
      "description": "Pan fresco del día",
      "image":
          "https://i5.walmartimages.cl/asr/c09e0e1f-e092-493a-b07c-a22255a12c6b.3fdecc24976f2836cc1cf5c7589a6fd0.jpeg?null",
      "category": "Panadería",
    },
    {
      "id": "4",
      "name": "Azúcar",
      "description": "Azúcar granulada",
      "image":
          "https://i5.walmartimages.cl/asr/c6102c27-86bd-459c-ac74-6c1bc31dfe35.b1e7bc38a04e76a3632ca1da958b45ca.jpeg?null",
      "category": "Alimentos",
    },
    {
      "id": "5",
      "name": "Queso",
      "description": "Queso laminado",
      "image":
          "https://www.mitiendacolun.cl/media/catalog/product/q/u/queso_ranco_laminado_semirigido_500gr.jpg?quality=80&bg-color=255,255,255&fit=bounds&height=700&width=700&canvas=700:700",
      "category": "Lácteos",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ItemDetailScreen(product: items[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.deepPurpleAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${items[index]['id']}. ${items[index]['name']}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      items[index]['category'],
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

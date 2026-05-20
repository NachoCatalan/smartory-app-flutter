import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smartory_app/presentation/providers/providers.dart';

import '../../widgets/widgets.dart';

final List<Map<String, dynamic>> expiringItems = [
  {'id': 1, 'productName': 'Arroz Grano Largo', 'expiresIn': '2 días'},
  {'id': 2, 'productName': 'Yogurt Griego Soprole', 'expiresIn': '1 día'},
  {'id': 3, 'productName': 'Pan Integral', 'expiresIn': '3 días'},
  {'id': 4, 'productName': 'Queso Gauda Laminado', 'expiresIn': '5 días'},
  {'id': 5, 'productName': 'Leche Descremada Colun', 'expiresIn': '4 días'},
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncProducts = ref.read(productsProvider);
    final logout = ref.read(authProvider.notifier).logout;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: AppbarTitle(),
      ),
      body: Material(
        color: Color.fromARGB(65, 224, 224, 255),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 15,
              bottom: 70,
            ),
            child: Column(
              spacing: 20,
              children: [
                ResumeInventoryCard(
                  number: 124,
                  title: 'Total productos',
                  color: Colors.blueAccent,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ResumeInventoryCard(
                        number: 8,
                        title: 'Por Vencer',
                        hasShadow: true,
                        fontSize: 14,
                        color: Colors.pink,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ResumeInventoryCard(
                        number: 8,
                        title: 'Stock Bajo',
                        hasShadow: true,
                        fontSize: 14,
                        color: Colors.cyan,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffe0e0ff),
                    borderRadius: BorderRadius.circular(12),
                    border: BoxBorder.all(width: 0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blueAccent,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.wifi_tethering,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Te quedan 2 días para consumir el yogurt griego. ¡Ideal para un smoothie!',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Acciones rápidas',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: QuickActionsCard(
                        icon: Icons.mic,
                        title: 'AGREGAR POR VOZ',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: QuickActionsCard(
                        icon: Icons.receipt_long,
                        title: 'ESCANEAR BOLETA',
                        isSelected: true,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: QuickActionsCard(
                        icon: Icons.qr_code_scanner_rounded,
                        title: 'ESCANEAR PRODUCTO',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        'Vencen pronto',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Ver más',
                        style: TextStyle(
                          color: Color(0xff3f49e0),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: expiringItems.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = expiringItems[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.only(right: 20),
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(15),
                                child: Image.network(
                                  'https://i5.walmartimages.cl/asr/dd56b017-8cc8-4568-884a-ae89b7408c93.134c201abf3c62ed282246e18bcc7d24.jpeg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text(
                                'Yogurt Griego',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Vence en 2 días',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.red.shade800,
                                ),
                              ),
                              SizedBox(height: 12),
                              LinearProgressIndicator(value: 0.8),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        'Stock bajo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Ver más',
                        style: TextStyle(
                          color: Color(0xff3f49e0),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: expiringItems.length,
                        itemBuilder: (context, index) {
                          final item = expiringItems[index];
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: Colors.blueAccent,
                                      ),
                                      Expanded(
                                        child: Text(
                                          item['productName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '1 UNIDAD',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text(
                    'Nuevos en catálogo',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: expiringItems.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = expiringItems[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              margin: EdgeInsets.only(right: 20),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    100,
                                  ),
                                  child: Image.network(
                                    'https://i5.walmartimages.cl/asr/dd56b017-8cc8-4568-884a-ae89b7408c93.134c201abf3c62ed282246e18bcc7d24.jpeg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Yogurt Griego',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  height: 1,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.2, color: Colors.indigo),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Home', style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Inventory', style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: () async {
                  await logout();
                },
                child: Text('Cerrar sesión', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppbarTitle extends StatelessWidget {
  const AppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            child: Image.network(
              'https://img3.stockfresh.com/files/k/kraska/m/97/808337_stock-photo-user-icon.jpg',
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              'Hola, Username',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              'BIENVENIDO A SMARTORY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

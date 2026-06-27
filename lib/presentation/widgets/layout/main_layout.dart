import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartory_app/presentation/screens/catalog/catalog_screen.dart';
import 'package:smartory_app/presentation/screens/home/home_screen.dart';
import 'package:smartory_app/presentation/screens/inventory/inventory_screen.dart';
import 'package:smartory_app/presentation/widgets/buttons/buttons.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final pageController = PageController();
  int currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [HomeScreen(), CatalogScreen(), InventoryScreen()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AudioMedia(),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        height: 50,
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () => {changePage(0)},
                  icon: currentIndex == 0
                      ? const Icon(
                          Icons.home_rounded,
                          color: Colors.indigoAccent,
                        )
                      : const Icon(Icons.home_outlined),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    context.push('/camera');
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
              ),
              const SizedBox(width: 70), // espacio para el botón central
              Expanded(
                child: IconButton(
                  onPressed: () => {changePage(1)},
                  icon: currentIndex == 1
                      ? const Icon(
                          Icons.grid_view_outlined,
                          color: Colors.indigoAccent,
                        )
                      : const Icon(Icons.grid_view),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () => {changePage(2)},
                  icon: currentIndex == 2
                      ? const Icon(Icons.inventory, color: Colors.indigoAccent)
                      : const Icon(Icons.inventory_2_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

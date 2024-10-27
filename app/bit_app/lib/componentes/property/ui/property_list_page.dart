import 'package:bit_app/componentes/property/property.dart';
import 'package:bit_app/componentes/property/ui/property_detail_page.dart';
import 'package:bit_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyListPage extends StatelessWidget {
  final bool showFilterBar;
  final propertyController = Get.put(PropertyController(), permanent: true);

  PropertyListPage({super.key, this.showFilterBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Get.to(() => PropertyForm(property: PropertyData.emptyInstance()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 10, 175, 254),
          fixedSize: const Size(70, 60),
        ),
        child: const Row(
          children: [
            Text(
              "+",
              style: TextStyle(fontSize: 38, color: Colors.white),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt), // TODO: add filters
            onPressed: () {},
          )
        ],
        centerTitle: true,
        title: const Text("Propiedades"),
        backgroundColor: const Color.fromARGB(255, 10, 175, 254),
        foregroundColor: Colors.white,
      ),
      drawer: const _Drawer(),
      body: const PropertyList(),
      bottomNavigationBar: null,
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 300,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 250),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
                color: Color.fromARGB(255, 10, 175, 254),
              ),
              height: 70,
              child: const LogedAccount(invertedColors: true, dense: true),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color.fromARGB(255, 255, 92, 92)),
                  onPressed: () async {
                    //TODO: add logout
                    // await TToolBox.get(LoginController()).logout();
                    // // ignore: use_build_context_synchronously
                    // context.goNamed(TRouteNames.Login.name);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

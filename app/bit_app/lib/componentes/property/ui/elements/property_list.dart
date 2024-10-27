import 'package:bit_app/componentes/property/property.dart';
import 'package:bit_app/componentes/property/ui/property_detail_page.dart';
import 'package:bit_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyList extends GetView<PropertyController> {
  const PropertyList({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) => Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.86,
            child: ListView.builder(
              itemCount: state!.length,
              itemBuilder: (context, index) =>
                  _PropertyListItem(property: state[index]),
            ),
          ),
        ],
      ),
      onEmpty: const EmptyList(),
      onLoading: const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 10, 175, 254),
        ),
      ),
      onError: (error) => Center(
          child: Text(
        error ?? 'Ha ocurrido un error al intentar cargar la lista',
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 202, 0, 0)),
      )),
    );
  }
}

class _PropertyListItem extends StatelessWidget {
  final PropertyData property;
  const _PropertyListItem({required this.property});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(property.name),
      subtitle: Text('${property.country}, ${property.city}'),
      trailing: IconButton(
          onPressed: () async {
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    DeleteDialog(propertyName: property.name));
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          )),
      onTap: () {
        Get.to(() => PropertyForm(
              property: property,
              readOnly: true,
            ));
      },
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({super.key, this.propertyName});
  final String? propertyName;
  final PropertyController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 255, 242, 242),
        title: Text(
          '¿Esta seguro que desea eliminar $propertyName?',
          style: const TextStyle(fontSize: 18, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Obx(() {
            if (controller.performingDelete.value) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 254, 10, 10),
                ),
              );
            }

            return TextButton(
              onPressed: () async {
                SE? result = await controller.deleteProperty(
                    id: controller.state!.first.id);
                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Propiedad eliminada con éxito"),
                    backgroundColor: Colors.green,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Propiedad eliminada con éxito"),
                    backgroundColor: Colors.green,
                  ));
                }

                Get.back();
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          })
        ]);
  }
}

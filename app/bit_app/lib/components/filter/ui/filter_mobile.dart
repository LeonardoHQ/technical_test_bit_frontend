import 'package:bit_app/components/filter/filter.dart';
import 'package:flutter/material.dart';

class FilterMobile extends StatelessWidget {
  final FilterController filterController;
  const FilterMobile({super.key, required this.filterController});

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: Colors.transparent,
      isLabelVisible: filterController.isAnyFilterActive(),
      label: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(left: 5, bottom: 20),
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      ),
      alignment: Alignment.center,
      child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => Theme(
                      data: Theme.of(context)
                          .copyWith(dialogBackgroundColor: Colors.white),
                      child: FilterDialog(
                        filterController: filterController,
                      ),
                    ));
          },
          icon: const Icon(Icons.filter_list)),
    );
  }
}

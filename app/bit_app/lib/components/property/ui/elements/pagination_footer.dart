// import 'package:flutter/material.dart';

// class PaginationFooter extends StatelessWidget {
//   final ResponsePageInfo? pageInfo;
//   final TRouteNames route;
//   final Map<String, String> queryParameters;
//   final bool dense;

//   const PaginationFooter({
//     super.key,
//     required this.pageInfo,
//     required this.route,
//     required this.queryParameters,
//     this.dense = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       padding: dense ? EdgeInsets.zero : const EdgeInsets.all(5),
//       child: Row(
//         mainAxisAlignment:
//             dense ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             onPressed: pageInfo == null || pageInfo!.page == 1
//                 ? null
//                 : () {
//                     queryParameters['page'] = (pageInfo!.page - 1).toString();
//                     context.goNamed(route.name,
//                         queryParameters: queryParameters);
//                   },
//             icon: Icon(Icons.keyboard_arrow_left,
//                 color: pageInfo == null || pageInfo!.page == 1
//                     ? Colors.grey[400]
//                     : Colors.black),
//           ),
//           Text(
//             '${dense ? '' : 'Página'} ${pageInfo?.page} de ${pageInfo?.totalPages}',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           IconButton(
//             onPressed: pageInfo == null || pageInfo!.isLastPage
//                 ? null
//                 : () {
//                     queryParameters['page'] = (pageInfo!.page + 1).toString();
//                     context.goNamed(route.name,
//                         queryParameters: queryParameters);
//                   },
//             icon: Icon(Icons.keyboard_arrow_right,
//                 color: pageInfo == null || pageInfo!.isLastPage
//                     ? Colors.grey[400]
//                     : Colors.black),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: Text(
//                 'Items por ${dense ? 'pág' : 'página.'}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               )),
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: DropdownButton(
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//                 items: const [
//                   DropdownMenuItem(
//                     value: '15',
//                     child: Text('15'),
//                   ),
//                   DropdownMenuItem(
//                     value: '25',
//                     child: Text('25'),
//                   ),
//                   DropdownMenuItem(
//                     value: '50',
//                     child: Text('50'),
//                   ),
//                   DropdownMenuItem(
//                     value: '100',
//                     child: Text('100'),
//                   ),
//                 ],
//                 value: queryParameters['pageSize'],
//                 onChanged: (value) {
//                   queryParameters['pageSize'] = value!;
//                   context.goNamed(route.name, queryParameters: queryParameters);
//                 }),
//           )
//         ],
//       ),
//     );
//   }
// }

library style_text_field_controller;

import 'package:flutter/material.dart';

import 'models/text_part_style_definition.dart';
import 'models/text_part_style_definitions.dart';

export 'models/text_part_style_definition.dart';
export 'models/text_part_style_definitions.dart';

part 'src/style_text_field_controller.dart';

//    How to Use
//    final TextEditingController textEditingController =
//         StyleableTextFieldController(
//       styles: TextPartStyleDefinitions(
//         definitionList: <TextPartStyleDefinition>[
//           TextPartStyleDefinition(
//             style: const TextStyle(
//               color: Colors.green,
//               fontWeight: FontWeight.bold,
//             ),
//             pattern: '[\.,\?\!]',
//           ),
//           TextPartStyleDefinition(
//             style: const TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//             pattern: '(?:(the|a|an) +)',
//           ),
//         ],
//       ),
//     );

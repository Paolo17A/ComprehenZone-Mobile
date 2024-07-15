import 'package:comprehenzone_mobile/utils/string_util.dart';

class ModulesModel {
  int index;
  String title;
  String documentPath;
  ModulesModel(
      {required this.index, required this.title, required this.documentPath});
}

final List<ModulesModel> Grade5Quarter1Modules = [
  ModulesModel(
      index: 1,
      title: 'Using Complex Sentences to Show a Cause and Effect Relationship',
      documentPath: DocumentPaths.grade5quarter1Lesson1),
  ModulesModel(
      index: 2,
      title: 'Inferring the Meaning of Words with Affixes Using Context Clues',
      documentPath: DocumentPaths.grade5quarter1Lesson2),
  ModulesModel(
      index: 3,
      title: 'Inferring the Meaning of Blended Words Using Context Clues',
      documentPath: DocumentPaths.grade5quarter1Lesson3),
  ModulesModel(
      index: 4,
      title: 'Inferring the Meaning of Clipped Words Using Context Clues',
      documentPath: DocumentPaths.grade5quarter1Lesson4),
];

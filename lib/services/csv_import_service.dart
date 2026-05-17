import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class CSVImportService {
  /// Ouvre un fichier CSV et retourne une liste de lignes (séparées en colonnes)
  static Future<List<List<String>>?> importCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt'],
      );

      if (result == null) return null;

      final bytes = result.files.single.bytes;
      if (bytes == null) return null;

      final content = utf8.decode(bytes);
      final lines = const LineSplitter().convert(content);

      return lines
          .map((line) => line.split(RegExp(r'[;,]')))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// Extrait une colonne numérique d’un CSV (ancienne méthode, toujours utile)
  static List<double> parseColumn(List<List<String>> rows, int col) {
    final List<double> values = [];

    for (final row in rows) {
      if (row.length > col) {
        final v = double.tryParse(row[col].trim());
        if (v != null) values.add(v);
      }
    }

    return values;
  }

  /// 🔥 Nouvelle méthode : extrait TOUTES les valeurs numériques du CSV
  /// Utile pour importer météo complète (48 valeurs) ou consommation (24 valeurs)
  static List<double> parseAllNumeric(List<List<String>> rows) {
    final List<double> values = [];

    for (final row in rows) {
      for (final cell in row) {
        final v = double.tryParse(cell.trim());
        if (v != null) values.add(v);
      }
    }

    return values;
  }
}

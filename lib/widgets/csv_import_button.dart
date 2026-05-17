import 'package:flutter/material.dart';
import '../services/csv_import_service.dart';

class CSVImportButton extends StatelessWidget {
  final String label;
  final Function(List<double>) onDataLoaded;

  const CSVImportButton({
    super.key,
    required this.label,
    required this.onDataLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file),
      label: Text(label),
      onPressed: () async {
        final rows = await CSVImportService.importCSV();
        if (rows == null) return;

        // 🔥 Nouvelle version : lit TOUTES les colonnes numériques
        final values = CSVImportService.parseAllNumeric(rows);

        if (values.isNotEmpty) {
          onDataLoaded(values);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Import réussi : ${values.length} valeurs"),
            ),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../services/pdf_service.dart';
import '../domain/project.dart';

class PdfViewerPage extends StatelessWidget {
  final Project project;

  const PdfViewerPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rapport PDF – ${project.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final bytes = await PdfService.buildProjectReport(project);
              await Printing.sharePdf(
                bytes: bytes,
                filename: 'rapport_${project.name}.pdf',
              );
            },
          ),
        ],
      ),

      // ⭐ Le PDF s'affiche ici
      body: PdfPreview(
        build: (format) => PdfService.buildProjectReport(project),

        // ⭐ IMPORTANT : empêche les rechargements infinis
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: true,
        canChangePageFormat: true,
        pdfFileName: 'rapport_${project.name}.pdf',
      ),
    );
  }
}

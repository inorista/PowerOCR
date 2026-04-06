import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:powerocr/core/services/interfaces/ipdf_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

@LazySingleton(as: IPdfService)
class PdfService implements IPdfService {
  @override
  Future<void> exportToPdf(List<String> imagePaths) async {
    final pdf = pw.Document();
    for (var imagePath in imagePaths) {
      final image = pw.MemoryImage(File(imagePath).readAsBytesSync());
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }
    final pdfBytes = await pdf.save();
    final xFile = XFile.fromData(
      pdfBytes,
      name: 'export.pdf',
      mimeType: 'application/pdf',
    );
    await SharePlus.instance.share(
      ShareParams(files: [xFile], subject: 'PDF Export'),
    );
  }
}

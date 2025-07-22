import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildEcgWaveformPdfPaint({
  required List<int> values,
  required double width,
  required double height,
}) {
  return pw.Container(
    width: width,
    height: height,
    child: pw.CustomPaint(
      size: PdfPoint(width, height),
      painter: (canvas, size) {
        if (values.length < 2) return;
        final minValue = values.reduce((a, b) => a < b ? a : b);
        final maxValue = values.reduce((a, b) => a > b ? a : b);
        canvas
          ..setStrokeColor(PdfColors.red)
          ..setLineWidth(1);
        for (int i = 1; i < values.length; i++) {
          final x1 = (i - 1) * (width / (values.length - 1));
          final y1 =
              height -
              ((values[i - 1] - minValue) * height / (maxValue - minValue + 1));
          final x2 = i * (width / (values.length - 1));
          final y2 =
              height -
              ((values[i] - minValue) * height / (maxValue - minValue + 1));
          canvas.moveTo(x1, y1);
          canvas.lineTo(x2, y2);
        }
        canvas.strokePath();
      },
    ),
  );
}

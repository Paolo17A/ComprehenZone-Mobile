import 'package:comprehenzone_mobile/utils/color_util.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class ViewPDFScreen extends StatefulWidget {
  final String pdfURL;
  const ViewPDFScreen({super.key, required this.pdfURL});

  @override
  State<ViewPDFScreen> createState() => _ViewPDFScreenState();
}

class _ViewPDFScreenState extends State<ViewPDFScreen> {
  late PDFDocument document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        extendBodyBehindAppBar: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: CustomColors.backgroundBlue,
          child: FutureBuilder(
            future: PDFDocument.fromURL(widget.pdfURL),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.hasError) {
                return Text('Error viewing PDF');
              }
              return PDFViewer(document: snapshot.data!);
            },
          ),
        ));
  }
}

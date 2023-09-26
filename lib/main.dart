import 'object.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

bool lang = false;
double a4Width = 794;
TextTranslation tt = TextTranslation();
List<PersonInfo> resumes = [];

void main() {
  runApp(const AutoResume());
}

class AutoResume extends StatelessWidget {
  const AutoResume({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: lang ? tt.resumeGenerator.zh : tt.resumeGenerator.en,
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String pdfName = lang ? tt.resumePdfName.zh : tt.resumePdfName.en;
  TabCtl tabCtl = TabCtl(
    isExtendSummary: true,
    isExtendProfessionalDevelopments: true,
    isExtendUrls: true,
    isExtendCoreCompetencies: true,
    isExtendEducations: true,
    isExtendCertifications: true,
    isExtendTechnicalProficiencies: true,
    isExtendCareerExperiences: true,
    isSelectSummary: true,
    isSelectUrls: true,
    isSelectCoreCompetencies: true,
    isSelectCertifications: true,
    isSelectEducations: true,
    isSelectProfessionalDevelopments: true,
    isSelectCareerExperiences: true,
    isSelectTechnicalProficiencies: true,
  );
  dynamic anchor;
  final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: a4Width,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: resumeGenerator(),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextButton(
                      child: const Text('Press'),
                      onPressed: () {
                        createPDF();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = pdfName;

    html.document.body?.children.add(anchor);

    anchor.click();
  }

  createPDF() async {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Hello World', style: const pw.TextStyle(fontSize: 40)),
          ],
        ),
      ),
    );

    savePDF();
  }

  List<Widget> resumeGenerator() {
    List<Widget> ret = [];

    for (var i = 0; i < 1000; i++) {
      ret.add(Text("$i\n"));
    }

    return ret;
  }
}

import 'object.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

int mainResume = -1;
bool lang = false;
double a4Width = 794;
TextTranslation tt = TextTranslation();
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
List<PersonInfo> resumes = [];

void main() {
  runApp(const AutoResume());
}

class AutoResume extends StatelessWidget {
  const AutoResume({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Resume Generator",
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
  int newIndex = 0;

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
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Column(
                children: resumeGenerator(),
              ),
            ),
            Expanded(
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        lang ? tt.languageSetting.zh : tt.languageSetting.en,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                side: const BorderSide(width: 1),
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                setState(() {
                                  lang = false;
                                });
                              },
                              child: Text(
                                lang ? tt.languageEN.zh : tt.languageEN.en,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                side: const BorderSide(width: 1),
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                setState(() {
                                  lang = true;
                                });
                              },
                              child: Text(
                                lang ? tt.languageZH.zh : tt.languageZH.en,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        lang ? tt.resumeSwitch.zh : tt.resumeSwitch.en,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                side: const BorderSide(width: 1),
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                setState(() {
                                  resumes.removeWhere((item) => item.alias == resumes[mainResume].alias);
                                  mainResume = -1;
                                });
                              },
                              child: Text(
                                lang ? tt.deleteResume.zh : tt.deleteResume.en,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              style: TextButton.styleFrom(
                                side: const BorderSide(width: 1),
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                setState(() {
                                  newIndex++;
                                  resumes.add(connectionEn.newCopy(newAlias: "${connectionEn.alias} #$newIndex"));
                                  mainResume = 0;
                                });
                              },
                              child: Text(
                                lang ? tt.loadSample.zh : tt.loadSample.en,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: resumes.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 5);
                          },
                          itemBuilder: (context, index) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                side: const BorderSide(width: 1),
                                padding: const EdgeInsets.all(15),
                                backgroundColor: mainResume == index ? Colors.grey : Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  mainResume = index;
                                });
                              },
                              child: Text(
                                resumes[index].alias,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                        lang ? tt.resumeSetting.zh : tt.resumeSetting.en,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: mainResume == -1
                          ? <Widget>[
                              const SizedBox(height: 10),
                              Text(
                                lang ? tt.noResumeSelect.zh : tt.noResumeSelect.en,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                lang ? tt.pleaseSelect.zh : tt.pleaseSelect.en,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ]
                          : <Widget>[
                              const SizedBox(height: 10),
                              ExpansionTile(
                                title: Text(
                                  lang ? tt.basicInfo.zh : tt.basicInfo.en,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                      children: [
                                        TextField(
                                          controller: TextEditingController(text: resumes[mainResume].name),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(),
                                            labelText: lang ? tt.basicInfoName.zh : tt.basicInfoName.en,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                style: TextButton.styleFrom(
                                  side: const BorderSide(width: 1),
                                  padding: const EdgeInsets.all(20),
                                ),
                                onPressed: () {
                                  createPDF();
                                },
                                child: Text(
                                  lang ? tt.generate.zh : tt.generate.en,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = resumes[mainResume].alias;

    html.document.body?.children.add(anchor);

    anchor.click();
  }

  List<Widget> resumeGenerator() {
    List<Widget> ret = [];

    for (var i = 0; i < 1000; i++) {
      ret.add(Text("$i\n"));
    }

    return ret;
  }
}

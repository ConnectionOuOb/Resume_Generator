import 'package:flutter/services.dart';

import 'object.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

int mainResume = -1;
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
      title: "Resume Generator",
      theme: ThemeData(fontFamily: 'NotoSansTC'),
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
  ByteData pdfFont = ByteData(0);
  dynamic anchor;
  final pdf = pw.Document();

  @override
  void initState() {
    loadFont();
    super.initState();
  }

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
              child: mainResume == -1
                  ? Center(
                      child: Text(
                        "${lang ? tt.noResumeSelect.zh : tt.noResumeSelect.en}\n\n${lang ? tt.pleaseSelect.zh : tt.pleaseSelect.en}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : resumeGenerator(),
            ),
            Expanded(
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ExpansionTile(
                      initiallyExpanded: true,
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
                      initiallyExpanded: true,
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
                      initiallyExpanded: true,
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
                          : resumeSetting(),
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

  loadFont() async {
    pdfFont = await rootBundle.load("fonts/NotoSansTC-Regular.ttf");
  }

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();

    final blob = html.Blob([pdfInBytes], 'application/pdf');

    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = html.Url.createObjectUrlFromBlob(blob)
      ..style.display = 'none'
      ..download = resumes[mainResume].alias;

    html.document.body?.children.add(anchor);

    anchor.click();
  }

  Widget resumeGenerator() {
    return Stack(
      children: [
        // # Name
        resumeAnchor(30, 30, 35, resumes[mainResume].name, true, false, Colors.black),

        // # Info
        resumeAnchor(520, 30, 15, '${resumes[mainResume].site}  ||  ${resumes[mainResume].phone}', false, false, Colors.black),
        resumeAnchor(520, 50, 15, resumes[mainResume].email, false, false, Colors.black),

        // # Qualifications Summary
        resumeAnchor(30, 90, 25, tt.basicSummary.en, false, true, Colors.black),
        resumeAnchor(30, 120, 18, resumes[mainResume].summary, false, false, Colors.black),

        // # Core Competencies
        resumeAnchor(30, 250, 25, tt.coreCompetencies.en, true, false, Colors.blue),
        resumeList(
          30,
          285,
          resumes[mainResume].coreCompetencies.map((entry) {
            return resumeText(18, "• $entry", false, false, Colors.black);
          }).toList(),
        ),

        // # Education
        resumeAnchor(30, 400, 25, tt.education.en, true, false, Colors.blue),
        resumeList(
          30,
          435,
          resumes[mainResume].educations.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                resumeText(16, '${entry.timeStart} - ${entry.timeEnd}', true, true, Colors.black),
                resumeText(15, entry.department, true, false, Colors.black),
                resumeText(16, entry.school, false, false, Colors.black),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),

        // # Professional Development
        resumeAnchor(30, 600, 25, tt.professionalDevelopment.en, true, false, Colors.blue),
        resumeList(
          30,
          635,
          resumes[mainResume].professionalDevelopments.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                resumeText(18, entry.category, true, false, Colors.black),
                resumeText(18, entry.description, false, false, Colors.black),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),

        // # Professional Development
        resumeAnchor(30, 700, 25, tt.technicalProficiencies.en, true, false, Colors.blue),
        resumeList(
          30,
          735,
          resumes[mainResume].technicalProficiencies.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                resumeText(18, entry.category, true, false, Colors.black),
                resumeText(16, entry.description, false, false, Colors.black),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ),

        // # Career Experience
        resumeAnchor(380, 250, 25, tt.careerExperience.en, true, false, Colors.blue),
        resumeList(
          380,
          285,
          resumes[mainResume].careerExperiences.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                resumeText(15, entry.companyName, false, false, Colors.black),
                const SizedBox(height: 5),
                resumeText(16, entry.jobTitle, true, false, Colors.black),
                const SizedBox(height: 10),
                resumeText(15, entry.summary, false, false, Colors.black),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entry.descriptions.map((description) {
                    return resumeText(15, "• $description", false, false, Colors.black);
                  }).toList(),
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget resumeAnchor(double left, top, fontSize, String content, bool isBold, isItalic, Color fontColor) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, 0, 0),
      child: resumeText(fontSize, content, isBold, isItalic, fontColor),
    );
  }

  Widget resumeText(double fontSize, String content, bool isBold, isItalic, Color fontColor) {
    return Text(
      content,
      style: isItalic
          ? TextStyle(color: fontColor, fontSize: fontSize, fontStyle: FontStyle.italic)
          : isBold
              ? TextStyle(color: fontColor, fontSize: fontSize, fontWeight: FontWeight.bold)
              : TextStyle(color: fontColor, fontSize: fontSize),
    );
  }

  Widget resumeList(double left, top, List<Widget> content) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, 0, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: content),
    );
  }

  pw.Widget resumeAnchorPDF(double left, top, fontSize, String content, bool isBold, isItalic, PdfColor fontColor) {
    return pw.Padding(
      padding: pw.EdgeInsets.fromLTRB(left / 1.3, top / 1.2, 0, 0),
      child: resumeTextPDF(fontSize, content, isBold, isItalic, fontColor),
    );
  }

  pw.Widget resumeTextPDF(double fontSize, String content, bool isBold, isItalic, PdfColor fontColor) {
    double scaleSize = fontSize / 1.4;
    return pw.Text(
      content,
      style: isItalic
          ? pw.TextStyle(color: fontColor, fontSize: scaleSize, fontStyle: pw.FontStyle.italic)
          : isBold
              ? pw.TextStyle(color: fontColor, fontSize: scaleSize, fontWeight: pw.FontWeight.bold)
              : pw.TextStyle(color: fontColor, fontSize: scaleSize, font: pw.Font.ttf(pdfFont)),
    );
  }

  pw.Widget resumeListPDF(double left, top, List<pw.Widget> content) {
    return pw.Padding(
      padding: pw.EdgeInsets.fromLTRB(left / 1.3, top / 1.2, 0, 0),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: content),
    );
  }

  List<Widget> resumeSetting() {
    TextEditingController basicAlias = TextEditingController(text: resumes[mainResume].alias);
    TextEditingController basicName = TextEditingController(text: resumes[mainResume].name);
    TextEditingController basicSite = TextEditingController(text: resumes[mainResume].site);
    TextEditingController basicPhone = TextEditingController(text: resumes[mainResume].phone);
    TextEditingController basicEmail = TextEditingController(text: resumes[mainResume].email);
    TextEditingController basicSummary = TextEditingController(text: resumes[mainResume].summary);
    List<TextEditingController> urlAlias = resumes[mainResume].urls.map((element) => TextEditingController(text: element.alias)).toList();
    List<TextEditingController> urlPaths = resumes[mainResume].urls.map((element) => TextEditingController(text: element.url)).toList();
    return <Widget>[
      // # Basic Info
      const SizedBox(height: 10),
      ExpansionTile(
        title: Text(
          lang ? tt.basic.zh : tt.basic.en,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: basicAlias,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang ? tt.basicAlias.zh : tt.basicAlias.en,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: TextField(
              controller: basicName,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang ? tt.basicName.zh : tt.basicName.en,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: TextField(
              controller: basicSite,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang ? tt.basicSite.zh : tt.basicSite.en,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: TextField(
              controller: basicPhone,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang ? tt.basicPhone.zh : tt.basicPhone.en,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: TextField(
              controller: basicEmail,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang ? tt.basicEmail.zh : tt.basicEmail.en,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: TextField(
              maxLines: 10,
              controller: basicSummary,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: lang ? tt.basicSummary.zh : tt.basicSummary.en,
              ),
            ),
          ),
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
                    resumes[mainResume].alias = basicAlias.text;
                    resumes[mainResume].name = basicName.text;
                    resumes[mainResume].site = basicSite.text;
                    resumes[mainResume].phone = basicPhone.text;
                    resumes[mainResume].email = basicEmail.text;
                    resumes[mainResume].summary = basicSummary.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text(lang ? tt.basicSaveSuccess.zh : tt.basicSaveSuccess.en),
                      ),
                    );
                  });
                },
                child: Text(
                  lang ? tt.basicSave.zh : tt.basicSave.en,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),

      // # Url
      const SizedBox(height: 10),
      ExpansionTile(
        title: Text(
          lang ? tt.url.zh : tt.url.en,
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            itemCount: urlAlias.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 5);
            },
            itemBuilder: (context, urlIndex) {
              return Column(
                children: [
                  Text("# No. ${urlIndex + 1}", style: const TextStyle(color: Colors.black, fontSize: 20)),
                  const SizedBox(height: 5),
                  ListTile(
                    title: TextField(
                      controller: urlAlias[urlIndex],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: lang ? tt.urlAlias.zh : tt.urlAlias.en,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListTile(
                    title: TextField(
                      controller: urlPaths[urlIndex],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: lang ? tt.urlPath.zh : tt.urlPath.en,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
                    resumes[mainResume].urls.add(Url(alias: '', url: ''));
                  });
                },
                child: Text(
                  lang ? tt.urlNew.zh : tt.urlNew.en,
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
                    resumes[mainResume].urls.removeLast();
                  });
                },
                child: Text(
                  lang ? tt.urlDel.zh : tt.urlDel.en,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text(lang ? tt.urlSaveSuccess.zh : tt.urlSaveSuccess.en),
                      ),
                    );
                  });
                },
                child: Text(
                  lang ? tt.urlSave.zh : tt.urlSave.en,
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

      // # Save PDF
      const SizedBox(height: 10),
      TextButton(
        style: TextButton.styleFrom(
          side: const BorderSide(width: 1),
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () {
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: const pw.EdgeInsets.all(0),
              build: (pw.Context context) => pw.Stack(
                children: <pw.Widget>[
                  // # Name
                  resumeAnchorPDF(30, 30, 35, resumes[mainResume].name, true, false, PdfColor.fromHex("#000000")),

                  // # Info
                  resumeAnchorPDF(520, 30, 15, '${resumes[mainResume].site} • ${resumes[mainResume].phone}', false, false, PdfColor.fromHex("#000000")),
                  resumeAnchorPDF(520, 50, 15, resumes[mainResume].email, false, false, PdfColor.fromHex("#000000")),

                  // # Qualifications Summary
                  resumeAnchorPDF(30, 90, 25, tt.basicSummary.en, false, true, PdfColor.fromHex("#000000")),
                  resumeAnchorPDF(30, 120, 18, resumes[mainResume].summary, false, false, PdfColor.fromHex("#000000")),

                  // # Core Competencies
                  resumeAnchorPDF(30, 250, 25, tt.coreCompetencies.en, true, false, PdfColor.fromHex("#0000FF")),
                  resumeListPDF(
                    30,
                    285,
                    resumes[mainResume].coreCompetencies.map((entry) {
                      return resumeTextPDF(18, "• $entry", false, false, PdfColor.fromHex("#000000"));
                    }).toList(),
                  ),

                  // # Education
                  resumeAnchorPDF(30, 400, 25, tt.education.en, true, false, PdfColor.fromHex("#0000FF")),
                  resumeListPDF(
                    30,
                    435,
                    resumes[mainResume].educations.map((entry) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          resumeTextPDF(16, '${entry.timeStart} - ${entry.timeEnd}', true, true, PdfColor.fromHex("#000000")),
                          resumeTextPDF(15, entry.department, true, false, PdfColor.fromHex("#000000")),
                          resumeTextPDF(16, entry.school, false, false, PdfColor.fromHex("#000000")),
                          pw.SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),

                  // # Professional Development
                  resumeAnchorPDF(30, 600, 25, tt.professionalDevelopment.en, true, false, PdfColor.fromHex("#0000FF")),
                  resumeListPDF(
                    30,
                    635,
                    resumes[mainResume].professionalDevelopments.map((entry) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          resumeTextPDF(18, entry.category, true, false, PdfColor.fromHex("#000000")),
                          resumeTextPDF(18, entry.description, false, false, PdfColor.fromHex("#000000")),
                          pw.SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),

                  // # Professional Development
                  resumeAnchorPDF(30, 700, 25, tt.technicalProficiencies.en, true, false, PdfColor.fromHex("#0000FF")),
                  resumeListPDF(
                    30,
                    735,
                    resumes[mainResume].technicalProficiencies.map((entry) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          resumeTextPDF(18, entry.category, true, false, PdfColor.fromHex("#000000")),
                          resumeTextPDF(16, entry.description, false, false, PdfColor.fromHex("#000000")),
                          pw.SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),

                  // # Career Experience
                  resumeAnchorPDF(380, 250, 25, tt.careerExperience.en, true, false, PdfColor.fromHex("#0000FF")),
                  resumeListPDF(
                    380,
                    285,
                    resumes[mainResume].careerExperiences.map((entry) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          resumeTextPDF(15, entry.companyName, false, false, PdfColor.fromHex("#000000")),
                          pw.SizedBox(height: 5),
                          resumeTextPDF(16, entry.jobTitle, true, false, PdfColor.fromHex("#000000")),
                          pw.SizedBox(height: 10),
                          resumeTextPDF(15, entry.summary, false, false, PdfColor.fromHex("#000000")),
                          pw.SizedBox(height: 10),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: entry.descriptions.map((description) {
                              return resumeTextPDF(15, "• $description", false, false, PdfColor.fromHex("#000000"));
                            }).toList(),
                          ),
                          pw.SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );

          savePDF();
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
    ];
  }
}

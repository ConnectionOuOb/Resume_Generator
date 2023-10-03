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
                            return const SizedBox(height: 7);
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
        resumeAnchor(30, 30, 30, resumes[mainResume].name, true, false, Colors.black),

        // # Info
        resumeAnchor(520, 30, 12, '${resumes[mainResume].site}  •  ${resumes[mainResume].phone}', false, false, Colors.black),
        resumeAnchor(520, 50, 12, resumes[mainResume].email, false, false, Colors.black),

        // # Qualifications Summary
        resumeAnchor(30, 90, 22, tt.basicSummary.en, false, true, Colors.black),
        resumeAnchor(30, 120, 15, resumes[mainResume].summary, false, false, Colors.black),

        // # Core Competencies
        if (resumes[mainResume].coreCompetencies.isNotEmpty) resumeAnchor(30, 250, 22, tt.coreCompetencies.en, true, false, Colors.blue),
        if (resumes[mainResume].coreCompetencies.isNotEmpty)
          resumeList(
            30,
            285,
            resumes[mainResume].coreCompetencies.map((entry) {
              return resumeText(16, "• $entry", false, false, Colors.black);
            }).toList(),
          ),

        // # Education
        if (resumes[mainResume].educations.isNotEmpty) resumeAnchor(30, 400, 23, tt.education.en, true, false, Colors.blue),
        if (resumes[mainResume].educations.isNotEmpty)
          resumeList(
            30,
            435,
            resumes[mainResume].educations.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resumeText(14, '${entry.timeStart} - ${entry.timeEnd}', true, true, Colors.black),
                  resumeText(14, entry.department, true, false, Colors.black),
                  resumeText(14, entry.school, false, false, Colors.black),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),

        // # Certifications
        if (resumes[mainResume].certifications.isNotEmpty) resumeAnchor(30, 600, 23, tt.certifications.en, true, false, Colors.blue),
        if (resumes[mainResume].certifications.isNotEmpty)
          resumeList(
            30,
            635,
            resumes[mainResume].certifications.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resumeText(16, entry.description, true, false, Colors.black),
                  resumeText(16, entry.organization, false, false, Colors.black),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),

        // # Professional Development
        if (resumes[mainResume].professionalDevelopments.isNotEmpty) resumeAnchor(30, 600, 23, tt.professionalDevelopment.en, true, false, Colors.blue),
        if (resumes[mainResume].professionalDevelopments.isNotEmpty)
          resumeList(
            30,
            635,
            resumes[mainResume].professionalDevelopments.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resumeText(16, entry.category, true, false, Colors.black),
                  resumeText(16, entry.description, false, false, Colors.black),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),

        // # Professional Development
        if (resumes[mainResume].technicalProficiencies.isNotEmpty) resumeAnchor(30, 700, 23, tt.technicalProficiencies.en, true, false, Colors.blue),
        if (resumes[mainResume].technicalProficiencies.isNotEmpty)
          resumeList(
            30,
            735,
            resumes[mainResume].technicalProficiencies.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resumeText(16, entry.category, true, false, Colors.black),
                  resumeText(14, entry.description, false, false, Colors.black),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),

        // # Career Experience
        if (resumes[mainResume].careerExperiences.isNotEmpty) resumeAnchor(380, 250, 23, tt.careerExperience.en, true, false, Colors.blue),
        if (resumes[mainResume].careerExperiences.isNotEmpty)
          resumeList(
            380,
            285,
            resumes[mainResume].careerExperiences.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resumeText(15, entry.companyName, false, false, Colors.black),
                  const SizedBox(height: 2),
                  resumeText(16, entry.jobTitle, true, false, Colors.black),
                  const SizedBox(height: 2),
                  resumeText(16, "${entry.timeStart} ~ ${entry.timeEnd}", false, true, Colors.black),
                  const SizedBox(height: 2),
                  resumeText(15, entry.summary, false, false, Colors.black),
                  const SizedBox(height: 5),
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
    List<TextEditingController> inputPart20 = resumes[mainResume].coreCompetencies.map((element) => TextEditingController(text: element)).toList();
    List<TextEditingController> inputPart31 = resumes[mainResume].educations.map((element) => TextEditingController(text: element.timeStart)).toList();
    List<TextEditingController> inputPart32 = resumes[mainResume].educations.map((element) => TextEditingController(text: element.timeEnd)).toList();
    List<TextEditingController> inputPart33 = resumes[mainResume].educations.map((element) => TextEditingController(text: element.school)).toList();
    List<TextEditingController> inputPart34 = resumes[mainResume].educations.map((element) => TextEditingController(text: element.department)).toList();
    List<TextEditingController> inputPart41 = resumes[mainResume].certifications.map((element) => TextEditingController(text: element.description)).toList();
    List<TextEditingController> inputPart42 = resumes[mainResume].certifications.map((element) => TextEditingController(text: element.organization)).toList();
    List<TextEditingController> inputPart51 = resumes[mainResume].professionalDevelopments.map((element) => TextEditingController(text: element.category)).toList();
    List<TextEditingController> inputPart52 = resumes[mainResume].professionalDevelopments.map((element) => TextEditingController(text: element.description)).toList();
    List<TextEditingController> inputPart61 = resumes[mainResume].technicalProficiencies.map((element) => TextEditingController(text: element.category)).toList();
    List<TextEditingController> inputPart62 = resumes[mainResume].technicalProficiencies.map((element) => TextEditingController(text: element.description)).toList();
    List<TextEditingController> inputPart71 = resumes[mainResume].careerExperiences.map((element) => TextEditingController(text: element.timeStart)).toList();
    List<TextEditingController> inputPart72 = resumes[mainResume].careerExperiences.map((element) => TextEditingController(text: element.timeEnd)).toList();
    List<TextEditingController> inputPart73 = resumes[mainResume].careerExperiences.map((element) => TextEditingController(text: element.companyName)).toList();
    List<TextEditingController> inputPart74 = resumes[mainResume].careerExperiences.map((element) => TextEditingController(text: element.jobTitle)).toList();
    List<TextEditingController> inputPart75 = resumes[mainResume].careerExperiences.map((element) => TextEditingController(text: element.summary)).toList();
    List<List<TextEditingController>> inputPart76 = resumes[mainResume].careerExperiences.map((element) => element.descriptions.map((e) => TextEditingController(text: e)).toList()).toList();
    return <Widget>[
      // # 1. Basic Info
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpansionTile(
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
                          content: Text(lang ? tt.itemSaveSuccess.zh : tt.itemSaveSuccess.en),
                        ),
                      );
                    });
                  },
                  child: Text(
                    lang ? tt.itemSave.zh : tt.itemSave.en,
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
      ),
      const SizedBox(height: 10),

      // # 2. Core Competencies
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpansionTile(
          title: Text(
            lang ? tt.coreCompetenciesSetting.zh : tt.coreCompetenciesSetting.en,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: inputPart20.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 7);
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart20[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.coreCompetency.zh : tt.coreCompetency.en,
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
                      resumes[mainResume].coreCompetencies.add('');
                    });
                  },
                  child: Text(
                    lang ? tt.itemNew.zh : tt.itemNew.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                if (resumes[mainResume].coreCompetencies.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        resumes[mainResume].coreCompetencies.removeLast();
                      });
                    },
                    child: Text(
                      lang ? tt.itemDel.zh : tt.itemDel.en,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
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
                      resumes[mainResume].coreCompetencies = inputPart20.asMap().entries.map((ele) => inputPart20[ele.key].text).toList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(lang ? tt.itemSaveSuccess.zh : tt.itemSaveSuccess.en),
                        ),
                      );
                    });
                  },
                  child: Text(
                    lang ? tt.itemSave.zh : tt.itemSave.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 10),

      // # 3. Education
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpansionTile(
          title: Text(
            lang ? tt.educationSetting.zh : tt.educationSetting.en,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: inputPart31.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 7);
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: inputPart31[index],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: lang ? tt.timeStart.zh : tt.timeStart.en,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20, child: Center(child: Text(" ~ "))),
                          Expanded(
                            child: TextField(
                              controller: inputPart32[index],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: lang ? tt.timeEnd.zh : tt.timeEnd.en,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart33[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.educationSchool.zh : tt.educationSchool.en,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart34[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.educationDepartment.zh : tt.educationDepartment.en,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.black),
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
                      resumes[mainResume].educations.add(Education(timeStart: '', timeEnd: '', school: '', department: ''));
                    });
                  },
                  child: Text(
                    lang ? tt.itemNew.zh : tt.itemNew.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                if (resumes[mainResume].educations.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        resumes[mainResume].educations.removeLast();
                      });
                    },
                    child: Text(
                      lang ? tt.itemDel.zh : tt.itemDel.en,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(side: const BorderSide(width: 1), padding: const EdgeInsets.all(15)),
                  onPressed: () {
                    setState(() {
                      resumes[mainResume].educations = inputPart31
                          .asMap()
                          .entries
                          .map(
                            (ele) => Education(
                              timeStart: inputPart31[ele.key].text,
                              timeEnd: inputPart32[ele.key].text,
                              school: inputPart33[ele.key].text,
                              department: inputPart34[ele.key].text,
                            ),
                          )
                          .toList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(lang ? tt.itemSaveSuccess.zh : tt.itemSaveSuccess.en),
                        ),
                      );
                    });
                  },
                  child: Text(
                    lang ? tt.itemSave.zh : tt.itemSave.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 10),

      // # 4.Certifications
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpansionTile(
          title: Text(
            lang ? tt.certificationsSetting.zh : tt.certificationsSetting.en,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: inputPart41.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 7);
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: TextField(
                        controller: inputPart41[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.certificationsDescription.zh : tt.certificationsDescription.en,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart42[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.certificationsOrganization.zh : tt.certificationsOrganization.en,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.black),
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
                      resumes[mainResume].certifications.add(Certification(organization: '', description: ''));
                    });
                  },
                  child: Text(
                    lang ? tt.itemNew.zh : tt.itemNew.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                if (resumes[mainResume].certifications.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        resumes[mainResume].certifications.removeLast();
                      });
                    },
                    child: Text(
                      lang ? tt.itemDel.zh : tt.itemDel.en,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(side: const BorderSide(width: 1), padding: const EdgeInsets.all(15)),
                  onPressed: () {
                    setState(() {
                      resumes[mainResume].certifications = inputPart41
                          .asMap()
                          .entries
                          .map(
                            (ele) => Certification(organization: inputPart42[ele.key].text, description: inputPart41[ele.key].text),
                          )
                          .toList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(lang ? tt.itemSaveSuccess.zh : tt.itemSaveSuccess.en),
                        ),
                      );
                    });
                  },
                  child: Text(
                    lang ? tt.itemSave.zh : tt.itemSave.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 10),

      // # 5. Professional Development
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpansionTile(
          title: Text(
            lang ? tt.professionalDevelopmentSetting.zh : tt.professionalDevelopmentSetting.en,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: inputPart51.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 7);
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: TextField(
                        controller: inputPart51[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.professionalDevelopmentDescription.zh : tt.professionalDevelopmentDescription.en,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart52[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.professionalDevelopmentOrganization.zh : tt.professionalDevelopmentOrganization.en,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.black),
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
                      resumes[mainResume].professionalDevelopments.add(CategoryDescription(category: '', description: ''));
                    });
                  },
                  child: Text(
                    lang ? tt.itemNew.zh : tt.itemNew.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                if (resumes[mainResume].professionalDevelopments.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        resumes[mainResume].professionalDevelopments.removeLast();
                      });
                    },
                    child: Text(
                      lang ? tt.itemDel.zh : tt.itemDel.en,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(side: const BorderSide(width: 1), padding: const EdgeInsets.all(15)),
                  onPressed: () {
                    setState(() {
                      resumes[mainResume].professionalDevelopments = inputPart51
                          .asMap()
                          .entries
                          .map(
                            (ele) => CategoryDescription(description: inputPart52[ele.key].text, category: inputPart51[ele.key].text),
                          )
                          .toList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(lang ? tt.itemSaveSuccess.zh : tt.itemSaveSuccess.en),
                        ),
                      );
                    });
                  },
                  child: Text(
                    lang ? tt.itemSave.zh : tt.itemSave.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 10),

      // # 6. Technical Proficiencies
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpansionTile(
          title: Text(
            lang ? tt.technicalProficienciesSetting.zh : tt.technicalProficienciesSetting.en,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: inputPart61.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 7);
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: TextField(
                        controller: inputPart61[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.technicalProficienciesCategory.zh : tt.technicalProficienciesCategory.en,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart62[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.technicalProficienciesDescription.zh : tt.technicalProficienciesDescription.en,
                        ),
                      ),
                    ),
                    const Divider(thickness: 1, color: Colors.black),
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
                      resumes[mainResume].technicalProficiencies.add(CategoryDescription(category: '', description: ''));
                    });
                  },
                  child: Text(
                    lang ? tt.itemNew.zh : tt.itemNew.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                if (resumes[mainResume].technicalProficiencies.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        resumes[mainResume].technicalProficiencies.removeLast();
                      });
                    },
                    child: Text(
                      lang ? tt.itemDel.zh : tt.itemDel.en,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(side: const BorderSide(width: 1), padding: const EdgeInsets.all(15)),
                  onPressed: () {
                    setState(() {
                      resumes[mainResume].technicalProficiencies = inputPart61
                          .asMap()
                          .entries
                          .map(
                            (ele) => CategoryDescription(description: inputPart62[ele.key].text, category: inputPart61[ele.key].text),
                          )
                          .toList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(lang ? tt.itemSaveSuccess.zh : tt.itemSaveSuccess.en),
                        ),
                      );
                    });
                  },
                  child: Text(
                    lang ? tt.itemSave.zh : tt.itemSave.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 10),

      // # 7. Career Experience
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpansionTile(
          title: Text(
            lang ? tt.careerExperienceSetting.zh : tt.careerExperienceSetting.en,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              itemCount: inputPart71.length,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 7);
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: inputPart71[index],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: lang ? tt.timeStart.zh : tt.timeStart.en,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20, child: Center(child: Text(" ~ "))),
                          Expanded(
                            child: TextField(
                              controller: inputPart72[index],
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: lang ? tt.timeEnd.zh : tt.timeEnd.en,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart73[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.careerExperienceCompany.zh : tt.careerExperienceCompany.en,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart74[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.careerExperienceJob.zh : tt.careerExperienceJob.en,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: TextField(
                        controller: inputPart75[index],
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: lang ? tt.careerExperienceSummary.zh : tt.careerExperienceSummary.en,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: ListView.separated(
                        shrinkWrap: true,
                        itemCount: inputPart76[index].length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, idx) {
                          return TextField(
                            controller: inputPart76[index][idx],
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: "${lang ? tt.careerFocus.zh : tt.careerFocus.en} #${idx + 1}",
                            ),
                          );
                        },
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
                              resumes[mainResume].careerExperiences[index].descriptions.add('');
                            });
                          },
                          child: Text(
                            lang ? tt.careerFocusAdd.zh : tt.careerFocusAdd.en,
                            style: const TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (resumes[mainResume].careerExperiences[index].descriptions.isNotEmpty)
                          TextButton(
                            style: TextButton.styleFrom(
                              side: const BorderSide(width: 1),
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              setState(() {
                                resumes[mainResume].careerExperiences[index].descriptions.removeLast();
                              });
                            },
                            child: Text(
                              lang ? tt.careerFocusDel.zh : tt.careerFocusDel.en,
                              style: const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                      ],
                    ),
                    const Divider(thickness: 1, color: Colors.black),
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
                      resumes[mainResume].careerExperiences.add(
                            CareerExperience(
                              timeStart: '',
                              timeEnd: '',
                              companyName: '',
                              jobTitle: '',
                              summary: '',
                              descriptions: [],
                            ),
                          );
                    });
                  },
                  child: Text(
                    lang ? tt.itemNew.zh : tt.itemNew.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
                if (resumes[mainResume].careerExperiences.isNotEmpty)
                  TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      setState(() {
                        resumes[mainResume].careerExperiences.removeLast();
                      });
                    },
                    child: Text(
                      lang ? tt.itemDel.zh : tt.itemDel.en,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                const SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(side: const BorderSide(width: 1), padding: const EdgeInsets.all(15)),
                  onPressed: () {
                    setState(() {
                      resumes[mainResume].careerExperiences = inputPart71
                          .asMap()
                          .entries
                          .map(
                            (ele) => CareerExperience(
                              timeStart: inputPart71[ele.key].text,
                              timeEnd: inputPart72[ele.key].text,
                              companyName: inputPart73[ele.key].text,
                              jobTitle: inputPart74[ele.key].text,
                              summary: inputPart75[ele.key].text,
                              descriptions: inputPart76[ele.key].map((m) => m.text).toList(),
                            ),
                          )
                          .toList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 1),
                          content: Text(lang ? tt.itemSaveSuccess.zh : tt.itemSaveSuccess.en),
                        ),
                      );
                    });
                  },
                  child: Text(
                    lang ? tt.itemSave.zh : tt.itemSave.en,
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      const SizedBox(height: 10),

      // # Save PDF
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
                  if (resumes[mainResume].coreCompetencies.isNotEmpty) resumeAnchorPDF(30, 250, 25, tt.coreCompetencies.en, true, false, PdfColor.fromHex("#0000FF")),
                  if (resumes[mainResume].coreCompetencies.isNotEmpty)
                    resumeListPDF(
                      30,
                      285,
                      resumes[mainResume].coreCompetencies.map((entry) {
                        return resumeTextPDF(18, "• $entry", false, false, PdfColor.fromHex("#000000"));
                      }).toList(),
                    ),

                  // # Education
                  if (resumes[mainResume].educations.isNotEmpty) resumeAnchorPDF(30, 400, 25, tt.education.en, true, false, PdfColor.fromHex("#0000FF")),
                  if (resumes[mainResume].educations.isNotEmpty)
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

                  // # Certifications
                  if (resumes[mainResume].certifications.isNotEmpty) resumeAnchorPDF(30, 600, 25, tt.certifications.en, true, false, PdfColor.fromHex("#0000FF")),
                  if (resumes[mainResume].certifications.isNotEmpty)
                    resumeListPDF(
                      30,
                      635,
                      resumes[mainResume].certifications.map((entry) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            resumeTextPDF(18, entry.description, true, false, PdfColor.fromHex("#000000")),
                            resumeTextPDF(18, entry.organization, false, false, PdfColor.fromHex("#000000")),
                            pw.SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),

                  // # Professional Development
                  if (resumes[mainResume].professionalDevelopments.isNotEmpty) resumeAnchorPDF(30, 600, 25, tt.professionalDevelopment.en, true, false, PdfColor.fromHex("#0000FF")),
                  if (resumes[mainResume].professionalDevelopments.isNotEmpty)
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
                  if (resumes[mainResume].technicalProficiencies.isNotEmpty) resumeAnchorPDF(30, 700, 25, tt.technicalProficiencies.en, true, false, PdfColor.fromHex("#0000FF")),
                  if (resumes[mainResume].technicalProficiencies.isNotEmpty)
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
                  if (resumes[mainResume].careerExperiences.isNotEmpty) resumeAnchorPDF(380, 250, 25, tt.careerExperience.en, true, false, PdfColor.fromHex("#0000FF")),
                  if (resumes[mainResume].careerExperiences.isNotEmpty)
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

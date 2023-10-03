import 'object.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;

int mainResume = -1;
bool lang = false;
double a4Width = 794;
TextTranslation tt = TextTranslation();
List<PersonInfo> resumes = [];
List<Block> uis = [
  // # 0. Basic Info
  Block(show: true, l: 30, t: 30, fontSize: 30, fontColor: 1, backgroundColor: 2, isBold: true, isItalic: false),
  Block(show: true, l: 500, t: 35, fontSize: 14, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),
  Block(show: true, l: 500, t: 55, fontSize: 14, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),

  // # 1. Qualifications Summary
  Block(show: true, l: 30, t: 90, fontSize: 22, fontColor: 1, backgroundColor: 2, isBold: true, isItalic: true),
  Block(show: true, l: 30, t: 130, fontSize: 15, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),

  // # 2. Core Competencies
  Block(show: true, l: 30, t: 250, fontSize: 23, fontColor: 3, backgroundColor: 2, isBold: true, isItalic: false),
  Block(show: true, l: 30, t: 285, fontSize: 15, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),

  // # 3. Education
  Block(show: true, l: 30, t: 410, fontSize: 23, fontColor: 3, backgroundColor: 2, isBold: true, isItalic: false),
  Block(show: true, l: 30, t: 445, fontSize: 15, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),

  // # 4. Certifications
  Block(show: false, l: 30, t: 600, fontSize: 23, fontColor: 3, backgroundColor: 2, isBold: true, isItalic: false),
  Block(show: false, l: 30, t: 635, fontSize: 15, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),

  // # 5. Professional Development
  Block(show: true, l: 30, t: 600, fontSize: 23, fontColor: 3, backgroundColor: 2, isBold: true, isItalic: false),
  Block(show: true, l: 30, t: 635, fontSize: 15, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),

  // # 6. Technical Proficiencies
  Block(show: true, l: 30, t: 700, fontSize: 23, fontColor: 3, backgroundColor: 2, isBold: true, isItalic: false),
  Block(show: true, l: 30, t: 735, fontSize: 15, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),

  // # 7. Career Experience
  Block(show: true, l: 410, t: 250, fontSize: 23, fontColor: 3, backgroundColor: 2, isBold: true, isItalic: false),
  Block(show: true, l: 410, t: 285, fontSize: 15, fontColor: 1, backgroundColor: 2, isBold: false, isItalic: false),
];
List<Block> uiPDFs = uis.map((ui) => ui.toPDF()).toList();

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

  Widget blockSetting(Block obj) {
    TextEditingController le = TextEditingController(text: obj.l.toString());
    TextEditingController te = TextEditingController(text: obj.t.toString());
    TextEditingController fe = TextEditingController(text: obj.fontSize.toString());

    le.selection = TextSelection.fromPosition(TextPosition(offset: le.text.length));
    te.selection = TextSelection.fromPosition(TextPosition(offset: te.text.length));
    fe.selection = TextSelection.fromPosition(TextPosition(offset: fe.text.length));
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 15),
            Flexible(
              child: TextField(
                controller: le,
                decoration: InputDecoration(border: const OutlineInputBorder(), labelText: lang ? tt.axisX.zh : tt.axisX.en),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  setState(() {
                    obj.l = double.parse(val);
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: TextField(
                controller: te,
                decoration: InputDecoration(border: const OutlineInputBorder(), labelText: lang ? tt.axisY.zh : tt.axisY.en),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  setState(() {
                    obj.t = double.parse(val);
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: TextField(
                controller: fe,
                decoration: InputDecoration(border: const OutlineInputBorder(), labelText: lang ? tt.fontSize.zh : tt.fontSize.en),
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                onChanged: (val) {
                  setState(() {
                    obj.fontSize = double.parse(val);
                  });
                },
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lang ? tt.show.zh : tt.show.en),
            Switch(
              value: obj.show,
              onChanged: (value) {
                setState(() {
                  obj.show = value;
                });
              },
            ),
            const SizedBox(width: 20),
            Text(lang ? tt.bold.zh : tt.bold.en),
            Switch(
              value: obj.isBold,
              onChanged: (value) {
                setState(() {
                  obj.isBold = value;
                });
              },
            ),
            const SizedBox(width: 20),
            Text(lang ? tt.italic.zh : tt.italic.en),
            Switch(
              value: obj.isItalic,
              onChanged: (value) {
                setState(() {
                  obj.isItalic = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget resumeGenerator() {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      child: Stack(
        children: [
          // # 0. Basic Info
          if (uis[0].show) resumeAnchor(uis[0], resumes[mainResume].name),
          if (uis[1].show) resumeAnchor(uis[1], '${resumes[mainResume].site} • ${resumes[mainResume].phone}'),
          if (uis[2].show) resumeAnchor(uis[2], resumes[mainResume].email),

          // # 1. Qualifications Summary
          if (uis[3].show) resumeAnchor(uis[3], tt.basicSummary.en),
          if (uis[4].show) resumeAnchor(uis[4], resumes[mainResume].summary),

          // # 2. Core Competencies
          if (uis[5].show) resumeAnchor(uis[5], tt.coreCompetencies.en),
          if (uis[6].show)
            resumeList(
              uis[6],
              resumes[mainResume].coreCompetencies.map((entry) {
                return resumeText(uis[6], "• $entry");
              }).toList(),
            ),

          // # 3. Education
          if (uis[7].show) resumeAnchor(uis[7], tt.education.en),
          if (uis[8].show)
            resumeList(
              uis[8],
              resumes[mainResume].educations.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resumeText(uis[8].toBold(), '${entry.timeStart} - ${entry.timeEnd}'),
                    resumeText(uis[8].toBold(), entry.department),
                    resumeText(uis[8], entry.school),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),

          // # 4. Certifications
          if (uis[9].show) resumeAnchor(uis[9], tt.certifications.en),
          if (uis[10].show)
            resumeList(
              uis[10],
              resumes[mainResume].certifications.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resumeText(uis[10].toBold(), entry.description),
                    resumeText(uis[10], entry.organization),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),

          // # 5. Professional Development
          if (uis[11].show) resumeAnchor(uis[11], tt.professionalDevelopment.en),
          if (uis[12].show)
            resumeList(
              uis[12],
              resumes[mainResume].professionalDevelopments.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resumeText(uis[12].toBold(), entry.category),
                    resumeText(uis[12], entry.description),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),

          // # 6. Professional Development
          if (uis[13].show) resumeAnchor(uis[13], tt.technicalProficiencies.en),
          if (uis[14].show)
            resumeList(
              uis[14],
              resumes[mainResume].technicalProficiencies.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resumeText(uis[14].toBold(), entry.category),
                    resumeText(uis[14], entry.description),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),

          // # 7. Career Experience
          if (uis[15].show) resumeAnchor(uis[15], tt.careerExperience.en),
          if (uis[16].show)
            resumeList(
              uis[16],
              resumes[mainResume].careerExperiences.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resumeText(uis[16].toBold(), "${entry.timeStart} ~ ${entry.timeEnd}"),
                    const SizedBox(height: 2),
                    resumeText(uis[16], entry.companyName),
                    const SizedBox(height: 2),
                    resumeText(uis[16].toBold(), entry.jobTitle),
                    const SizedBox(height: 2),
                    resumeText(
                      uis[16],
                      entry.summary,
                    ),
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: entry.descriptions.map((description) {
                        return resumeText(uis[16], "• $description");
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget resumeAnchor(Block setting, String content) {
    return Padding(
      padding: EdgeInsets.fromLTRB(setting.l, setting.t, 0, 0),
      child: resumeText(setting, content),
    );
  }

  Widget resumeText(Block setting, String content) {
    Color showColor = Colors.black;

    switch (setting.fontColor) {
      case 1:
        showColor = Colors.black;
        break;
      case 2:
        showColor = Colors.white;
        break;
      case 3:
        showColor = Colors.blue;
        break;
    }
    return Text(
      content,
      style: setting.isItalic
          ? TextStyle(color: showColor, fontSize: setting.fontSize, fontStyle: FontStyle.italic)
          : setting.isBold
              ? TextStyle(color: showColor, fontSize: setting.fontSize, fontWeight: FontWeight.bold)
              : TextStyle(color: showColor, fontSize: setting.fontSize),
    );
  }

  Widget resumeList(Block setting, List<Widget> content) {
    return Padding(
      padding: EdgeInsets.fromLTRB(setting.l, setting.t, 0, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: content),
    );
  }

  pw.Widget resumeAnchorPDF(Block setting, String content) {
    return pw.Padding(
      padding: pw.EdgeInsets.fromLTRB(setting.l, setting.t, 0, 0),
      child: resumeTextPDF(setting, content),
    );
  }

  pw.Widget resumeTextPDF(Block setting, String content) {
    PdfColor showColor = PdfColors.black;

    switch (setting.fontColor) {
      case 1:
        showColor = PdfColors.black;
        break;
      case 2:
        showColor = PdfColors.white;
        break;
      case 3:
        showColor = PdfColors.blue;
        break;
    }
    return pw.Text(
      content,
      style: setting.isItalic
          ? pw.TextStyle(color: showColor, fontSize: setting.fontSize, fontStyle: pw.FontStyle.italic)
          : setting.isBold
              ? pw.TextStyle(color: showColor, fontSize: setting.fontSize, fontWeight: pw.FontWeight.bold)
              : pw.TextStyle(color: showColor, fontSize: setting.fontSize, font: pw.Font.ttf(pdfFont)),
    );
  }

  pw.Widget resumeListPDF(Block setting, List<pw.Widget> content) {
    return pw.Padding(
      padding: pw.EdgeInsets.fromLTRB(setting.l, setting.t, 0, 0),
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
            Text(
              lang ? tt.posName.zh : tt.posName.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[0]),
            Text(
              lang ? tt.posDetail1.zh : tt.posDetail1.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[1]),
            Text(
              lang ? tt.posDetail2.zh : tt.posDetail2.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[2]),
            Text(
              lang ? tt.summaryTitle.zh : tt.summaryTitle.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[3]),
            Text(
              lang ? tt.summaryContent.zh : tt.summaryContent.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[4]),
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
            Text(
              lang ? tt.title.zh : tt.title.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[5]),
            Text(
              lang ? tt.content.zh : tt.content.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[6]),
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
            Text(
              lang ? tt.title.zh : tt.title.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[7]),
            Text(
              lang ? tt.content.zh : tt.content.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[8]),
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
            Text(
              lang ? tt.title.zh : tt.title.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[9]),
            Text(
              lang ? tt.content.zh : tt.content.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[10]),
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
            Text(
              lang ? tt.title.zh : tt.title.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[11]),
            Text(
              lang ? tt.content.zh : tt.content.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[12]),
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
            Text(
              lang ? tt.title.zh : tt.title.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[13]),
            Text(
              lang ? tt.content.zh : tt.content.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[14]),
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
            Text(
              lang ? tt.title.zh : tt.title.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[15]),
            Text(
              lang ? tt.content.zh : tt.content.en,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
            blockSetting(uis[16]),
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
          pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(0),
            build: (pw.Context context) => pw.Container(
              padding: const pw.EdgeInsets.only(right: 20 / 1.3),
              child: pw.Stack(
                children: <pw.Widget>[
                  // # 0. Basic Info
                  if (uiPDFs[0].show) resumeAnchorPDF(uiPDFs[0], resumes[mainResume].name),
                  if (uiPDFs[1].show) resumeAnchorPDF(uiPDFs[1], '${resumes[mainResume].site} • ${resumes[mainResume].phone}'),
                  if (uiPDFs[2].show) resumeAnchorPDF(uiPDFs[2], resumes[mainResume].email),

                  // # 1. Qualifications Summary
                  if (uiPDFs[3].show) resumeAnchorPDF(uiPDFs[3], tt.basicSummary.en),
                  if (uiPDFs[4].show) resumeAnchorPDF(uiPDFs[4], resumes[mainResume].summary),

                  // # 2. Core Competencies
                  if (uiPDFs[5].show) resumeAnchorPDF(uiPDFs[5], tt.coreCompetencies.en),
                  if (uiPDFs[6].show)
                    resumeListPDF(
                      uiPDFs[6],
                      resumes[mainResume].coreCompetencies.map((entry) {
                        return resumeTextPDF(uiPDFs[6], "• $entry");
                      }).toList(),
                    ),

                  // # 3. Education
                  if (uiPDFs[7].show) resumeAnchorPDF(uiPDFs[7], tt.education.en),
                  if (uiPDFs[8].show)
                    resumeListPDF(
                      uiPDFs[8],
                      resumes[mainResume].educations.map((entry) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            resumeTextPDF(uiPDFs[8].toBold(), '${entry.timeStart} - ${entry.timeEnd}'),
                            resumeTextPDF(uiPDFs[8].toBold(), entry.department),
                            resumeTextPDF(uiPDFs[8], entry.school),
                            pw.SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),

                  // # 4. Certifications
                  if (uiPDFs[9].show) resumeAnchorPDF(uiPDFs[9], tt.certifications.en),
                  if (uiPDFs[10].show)
                    resumeListPDF(
                      uiPDFs[10],
                      resumes[mainResume].certifications.map((entry) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            resumeTextPDF(uiPDFs[10].toBold(), entry.description),
                            resumeTextPDF(uiPDFs[10], entry.organization),
                            pw.SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),

                  // # 5. Professional Development
                  if (uiPDFs[11].show) resumeAnchorPDF(uiPDFs[11], tt.professionalDevelopment.en),
                  if (uiPDFs[12].show)
                    resumeListPDF(
                      uiPDFs[12],
                      resumes[mainResume].professionalDevelopments.map((entry) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            resumeTextPDF(uiPDFs[12].toBold(), entry.category),
                            resumeTextPDF(uiPDFs[12], entry.description),
                            pw.SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),

                  // # 6. Professional Development
                  if (uiPDFs[13].show) resumeAnchorPDF(uiPDFs[13], tt.technicalProficiencies.en),
                  if (uiPDFs[14].show)
                    resumeListPDF(
                      uiPDFs[14],
                      resumes[mainResume].technicalProficiencies.map((entry) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            resumeTextPDF(uiPDFs[14].toBold(), entry.category),
                            resumeTextPDF(uiPDFs[14], entry.description),
                            pw.SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),

                  // # 7. Career Experience
                  if (uiPDFs[15].show) resumeAnchorPDF(uiPDFs[15], tt.careerExperience.en),
                  if (uiPDFs[16].show)
                    resumeListPDF(
                      uiPDFs[16],
                      resumes[mainResume].careerExperiences.map((entry) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            resumeTextPDF(uiPDFs[16].toBold(), "${entry.timeStart} ~ ${entry.timeEnd}"),
                            pw.SizedBox(height: 2),
                            resumeTextPDF(uiPDFs[16], entry.companyName),
                            pw.SizedBox(height: 2),
                            resumeTextPDF(uiPDFs[16].toBold(), entry.jobTitle),
                            pw.SizedBox(height: 2),
                            resumeTextPDF(
                              uiPDFs[16],
                              entry.summary,
                            ),
                            pw.SizedBox(height: 5),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: entry.descriptions.map((description) {
                                return resumeTextPDF(uiPDFs[16], "• $description");
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
          ));

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
}

class TextTranslation {
  LocalText get resumePdfName => LocalText(en: "Resume.pdf", zh: "履歷.pdf");

  LocalText get resumeGenerator => LocalText(en: "Resume Generator", zh: "履歷產生器");
}

class LocalText {
  String en;
  String zh;

  LocalText({
    required this.en,
    required this.zh,
  });
}

class Education {
  String timeStart;
  String timeEnd;
  String school;
  String department;

  Education({
    required this.timeStart,
    required this.timeEnd,
    required this.school,
    required this.department,
  });
}

class Certification {
  String description;
  String organization;

  Certification({
    required this.description,
    required this.organization,
  });
}

class CategoryDescription {
  String category;
  String description;

  CategoryDescription({
    required this.category,
    required this.description,
  });
}

class CareerExperience {
  String companyName;
  String jobTitle;
  String timeStart;
  String timeEnd;
  String summary;
  List<String> descriptions;

  CareerExperience({
    required this.companyName,
    required this.jobTitle,
    required this.timeStart,
    required this.timeEnd,
    required this.summary,
    required this.descriptions,
  });
}

class PersonInfo {
  String name;
  String site;
  String phone;
  String email;
  String summary;
  List<String> urls;
  List<String> coreCompetencies;
  List<Education> educations;
  List<Certification> certifications;
  List<CategoryDescription> professionalDevelopments;
  List<CategoryDescription> technicalProficiencies;
  List<CareerExperience> careerExperiences;

  PersonInfo({
    required this.name,
    required this.site,
    required this.phone,
    required this.email,
    required this.summary,
    required this.urls,
    required this.coreCompetencies,
    required this.educations,
    required this.certifications,
    required this.professionalDevelopments,
    required this.technicalProficiencies,
    required this.careerExperiences,
  });
}

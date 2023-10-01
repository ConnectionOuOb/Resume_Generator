class TextTranslation {
  // ## Language
  LocalText get languageSetting => LocalText(
        en: "Language Setting",
        zh: "語言設定",
      );

  LocalText get languageEN => LocalText(
        en: "English",
        zh: "英文",
      );

  LocalText get languageZH => LocalText(
        en: "Chinese",
        zh: "中文",
      );

  // ## Switcher
  LocalText get resumeSwitch => LocalText(
        en: "Resume Switcher",
        zh: "履歷切換",
      );

  LocalText get deleteResume => LocalText(
        en: "Delete Resume",
        zh: "刪除履歷",
      );

  LocalText get loadSample => LocalText(
        en: "Load Sample",
        zh: "載入樣本",
      );

  // ## Setting
  LocalText get resumeSetting => LocalText(
        en: "Resume Setting",
        zh: "履歷設定",
      );

  LocalText get noResumeSelect => LocalText(
        en: "No Resume Selected!",
        zh: "尚未選取任何履歷!",
      );

  LocalText get pleaseSelect => LocalText(
        en: "select one at resume switcher",
        zh: "請在切換器選一個履歷",
      );

  // # Basic
  LocalText get basicInfo => LocalText(
        en: "Basic Information",
        zh: "基本資訊",
      );

  LocalText get basicInfoName => LocalText(
        en: "Name",
        zh: "姓名",
      );

  // ## Generate
  LocalText get generate => LocalText(
        en: "generate resume",
        zh: "生成履歷",
      );
}

class LocalText {
  String en;
  String zh;

  LocalText({
    required this.en,
    required this.zh,
  });
}

class TabCtl {
  bool isExtendSummary;
  bool isExtendUrls;
  bool isExtendCoreCompetencies;
  bool isExtendEducations;
  bool isExtendCertifications;
  bool isExtendProfessionalDevelopments;
  bool isExtendTechnicalProficiencies;
  bool isExtendCareerExperiences;
  bool isSelectSummary;
  bool isSelectUrls;
  bool isSelectCoreCompetencies;
  bool isSelectEducations;
  bool isSelectCertifications;
  bool isSelectProfessionalDevelopments;
  bool isSelectTechnicalProficiencies;
  bool isSelectCareerExperiences;

  TabCtl({
    required this.isExtendSummary,
    required this.isExtendUrls,
    required this.isExtendCoreCompetencies,
    required this.isExtendEducations,
    required this.isExtendCertifications,
    required this.isExtendProfessionalDevelopments,
    required this.isExtendTechnicalProficiencies,
    required this.isExtendCareerExperiences,
    required this.isSelectSummary,
    required this.isSelectUrls,
    required this.isSelectCoreCompetencies,
    required this.isSelectEducations,
    required this.isSelectCertifications,
    required this.isSelectProfessionalDevelopments,
    required this.isSelectTechnicalProficiencies,
    required this.isSelectCareerExperiences,
  });
}

class Url {
  String alias;
  String url;

  Url({
    required this.alias,
    required this.url,
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
  String alias;
  String name;
  String site;
  String phone;
  String email;
  String summary;
  List<Url> urls;
  List<String> coreCompetencies;
  List<Education> educations;
  List<Certification> certifications;
  List<CategoryDescription> professionalDevelopments;
  List<CategoryDescription> technicalProficiencies;
  List<CareerExperience> careerExperiences;

  PersonInfo newCopy({required String newAlias}) => PersonInfo(
        alias: newAlias,
        name: name,
        site: site,
        phone: phone,
        email: email,
        summary: summary,
        urls: urls,
        coreCompetencies: coreCompetencies,
        educations: educations,
        certifications: certifications,
        professionalDevelopments: professionalDevelopments,
        technicalProficiencies: technicalProficiencies,
        careerExperiences: careerExperiences,
      );

  PersonInfo({
    required this.alias,
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

PersonInfo connectionEn = PersonInfo(
  alias: 'English',
  name: 'Connection Lee',
  site: r'Hsinchu, Taiwan',
  phone: '+886-935354154',
  email: 'connection.bt12@nycu.edu.tw',
  summary:
      r'NYCU Bioinformatics and Systems Biology graduated with skills in big data analysis and modeling. Currently seeking aposition as a Data Scientist. I have gained experience of developing neural network models with Academia Sinica andworked as a Research and Development Engineer at Bovia, receiving a championship in the Chunghwa Telecom 5G Innovative Application Competition.',
  urls: [],
  coreCompetencies: [
    "Machine Learning",
    "Big Data Analysis",
    "System Design",
    "Full Stack Engineer",
  ],
  educations: [
    Education(
      timeStart: '2023',
      timeEnd: 'Present',
      school: r'National Yang Ming Chiao Tung University',
      department: 'Institute of Bioinformatics and Systems Biology',
    ),
    Education(
      timeStart: '2017',
      timeEnd: '2023',
      school: r'National Yang Ming Chiao Tung University',
      department: 'Department of Biological Science and Technology',
    ),
  ],
  certifications: [],
  professionalDevelopments: [
    CategoryDescription(
      category: 'Marine data modeling',
      description: 'Academia Sinica',
    ),
  ],
  technicalProficiencies: [
    CategoryDescription(
      category: 'Data Science',
      description: 'Python, Tensorflow, Scikit-Learn',
    ),
    CategoryDescription(
      category: 'Full stack',
      description: 'Golang, Dart/Flutter, MySQL, POSTGRESQL',
    ),
    CategoryDescription(
      category: 'Algorithm',
      description: 'Algorithm optimisation, Distributed computing',
    ),
    CategoryDescription(
      category: 'DevOps',
      description: 'Docker, Kubernetes, Proxmox VE',
    ),
    CategoryDescription(
      category: 'OS',
      description: 'Unix / Linux (Centos, Ubuntu)',
    ),
    CategoryDescription(
      category: 'Others',
      description: 'Git, MS Office Suite, Jira',
    ),
  ],
  careerExperiences: [
    CareerExperience(
      companyName: 'Dimension Computer Technology CO., LTD.',
      jobTitle: r'TSMC Onsite IT Assistant Engineer',
      timeStart: 'June 2023',
      timeEnd: 'September 2023',
      summary: '',
      descriptions: [],
    ),
    CareerExperience(
      companyName: r'BOVIA CO., LTD.',
      jobTitle: 'Software R&D Engineer',
      timeStart: 'January 2022',
      timeEnd: 'January 2024',
      summary: '',
      descriptions: [],
    ),
    CareerExperience(
      companyName: r'Computational Biology and Bioengineering Laboratory, IBSB, NYCU',
      jobTitle: 'MIS & IT Engineer',
      timeStart: 'September 2018',
      timeEnd: 'February 2023',
      summary: '',
      descriptions: [],
    ),
  ],
);

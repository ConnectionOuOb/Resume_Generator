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
  LocalText get basic => LocalText(
        en: "1. Basic Information",
        zh: "1. 基本資訊",
      );

  LocalText get basicAlias => LocalText(
        en: "Resume Alias",
        zh: "履歷別稱",
      );

  LocalText get basicName => LocalText(
        en: "Name",
        zh: "姓名",
      );

  LocalText get basicSite => LocalText(
        en: "Site",
        zh: "住址",
      );

  LocalText get basicPhone => LocalText(
        en: "Phone",
        zh: "電話",
      );

  LocalText get basicEmail => LocalText(
        en: "Email",
        zh: "電子郵箱",
      );

  LocalText get basicSummary => LocalText(
        en: "Qualifications Summary",
        zh: "資格摘要",
      );

  LocalText get basicSave => LocalText(
        en: "Save Basic Information",
        zh: "儲存基本資訊",
      );

  LocalText get basicSaveSuccess => LocalText(
        en: "Save Basic Information successful",
        zh: "成功儲存基本資訊",
      );

  // # Url
  LocalText get url => LocalText(
        en: "2. Urls",
        zh: "2. 超連結",
      );

  LocalText get urlAlias => LocalText(
        en: "Name",
        zh: "名稱",
      );

  LocalText get urlPath => LocalText(
        en: "Name",
        zh: "超連結位址",
      );

  LocalText get urlNew => LocalText(
        en: "Add an Url",
        zh: "新增一筆超連結",
      );

  LocalText get urlDel => LocalText(
        en: "Delete an Url",
        zh: "刪除一筆超連結",
      );

  LocalText get urlSave => LocalText(
        en: "Save Urls",
        zh: "儲存超連結",
      );

  LocalText get urlSaveSuccess => LocalText(
        en: "Save Urls successful",
        zh: "成功儲存超連結",
      );

  // ## Core Competencies
  LocalText get coreCompetencies => LocalText(
        en: "Core Competencies",
        zh: "核心競爭力",
      );

  // ## Core Competencies
  LocalText get education => LocalText(
        en: "Education",
        zh: "學歷",
      );

  // ## Core Competencies
  LocalText get professionalDevelopment => LocalText(
        en: "Professional Development",
        zh: "持續專業發展",
      );

  // ## Technical Proficiencies
  LocalText get technicalProficiencies => LocalText(
        en: "Technical Proficiencies",
        zh: "熟練技能",
      );

  // ## Career Experience
  LocalText get careerExperience => LocalText(
        en: "Career Experience",
        zh: "職涯經歷",
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
      summary: '123\n123\n123\n123',
      descriptions: [
        '*斜體字*',
        '**粗體字**',
        '***斜體兼粗體***',
      ],
    ),
    CareerExperience(
      companyName: r'BOVIA CO., LTD.',
      jobTitle: 'Software R&D Engineer',
      timeStart: 'January 2022',
      timeEnd: 'January 2024',
      summary: '123\n123\n123\n123',
      descriptions: [
        '1',
        '2',
        '3',
      ],
    ),
    CareerExperience(
      companyName: r'Computational Biology and Bioengineering Laboratory, IBSB, NYCU',
      jobTitle: 'MIS & IT Engineer',
      timeStart: 'September 2018',
      timeEnd: 'February 2023',
      summary: '123\n123\n123\n123',
      descriptions: [
        '1',
        '2',
        '3',
      ],
    ),
  ],
);

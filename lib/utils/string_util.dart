class ImagePaths {
  static const comprehenzoneLogo = 'assets/images/COMPREHENZONE LOGO.png';
  //static const loginBG = 'assets/images/BG WALLPAPER.png';
  static const schoolBG = 'assets/images/school bg.jpg';
  static const frontPageLogo = 'assets/images/logo frontpage.png';
  static const homeBG = 'assets/images/FIRST PAGE OPTIONS BG.jpg';
  static const homeBook = 'assets/images/home book.png';
  static const homeStudying = 'assets/images/studying.png';
  static const homeFeedback = 'assets/images/feedback.png';
  static const research = 'assets/images/research.png';
  static const drawerHome = 'assets/images/home.png';
  static const drawerProfile = 'assets/images/user.png';
  // static const profileBG = 'assets/images/PROFILE PAGE.jpg';
  static const profileUser = 'assets/images/profile-user.png';
  static const profileDateOfBirth = 'assets/images/date-of-birth.png';
  static const profileContactNumber = 'assets/images/mobile.png';
  static const profileID = 'assets/images/personal-id.png';
  static const defaultProfilePic = 'assets/images/student.png';
  //static const modulesBG = 'assets/images/LEARNING MATERIALS BG.jpg';
  static const quarterBooks = 'assets/images/books.png';
  static const quarterEasyToUse = 'assets/images/easy-to-use.png';
  static const quarterIdea = 'assets/images/idea.png';
  static const quarterReading = 'assets/images/reading-book 1.png';
  static const quizGB = 'assets/images/QUIZZES AND EXAM BG.jpg';
  static const gradesBG = 'assets/images/GRADE AND FEEDBACK BG.jpg';
}

class DocumentPaths {
  static const grade5quarter1Lesson1 =
      'assets/documents/Grade5Quarter1Lesson1.pdf';
  static const grade5quarter1Lesson2 =
      'assets/documents/Grade5Quarter1Lesson2.pdf';
  static const grade5quarter1Lesson3 =
      'assets/documents/Grade5Quarter1Lesson3.pdf';
  static const grade5quarter1Lesson4 =
      'assets/documents/Grade5Quarter1Lesson4.pdf';
  static const grade5quarter2Lesson1 =
      'assets/documents/Grade5Quarter2Lesson1.pdf';
  static const grade5quarter2Lesson2 =
      'assets/documents/Grade5Quarter2Lesson2.pdf';
  static const grade5quarter2Lesson3 =
      'assets/documents/Grade5Quarter2Lesson3.pdf';
  static const grade5quarter2Lesson4 =
      'assets/documents/Grade5Quarter2Lesson4.pdf';
  static const grade5quarter2Lesson5 =
      'assets/documents/Grade5Quarter2Lesson5.pdf';
  static const grade5quarter2Lesson6 =
      'assets/documents/Grade5Quarter2Lesson6.pdf';
  static const grade5quarter3Lesson1 =
      'assets/documents/Grade5Quarter3Lesson1.pdf';
  static const grade5quarter3Lesson2 =
      'assets/documents/Grade5Quarter3Lesson2.pdf';
  static const grade5quarter3Lesson3 =
      'assets/documents/Grade5Quarter3Lesson3.pdf';
  static const grade5quarter3Lesson4 =
      'assets/documents/Grade5Quarter3Lesson4.pdf';
  static const grade5quarter4Lesson1 =
      'assets/documents/Grade5Quarter4Lesson1.pdf';
  static const grade5quarter4Lesson2 =
      'assets/documents/Grade5Quarter4Lesson2.pdf';
  static const grade5quarter4Lesson3 =
      'assets/documents/Grade5Quarter4Lesson3.pdf';
  static const grade5quarter4Lesson4 =
      'assets/documents/Grade5Quarter4Lesson4.pdf';
  static const grade5quarter4Lesson5 =
      'assets/documents/Grade5Quarter4Lesson5.pdf';
  //  GRADE 6
  static const grade6quarter1Lesson1 =
      'assets/documents/Grade6Quarter1Lesson1.pdf';
  static const grade6quarter1Lesson2 =
      'assets/documents/Grade6Quarter1Lesson2.pdf';
  static const grade6quarter2Lesson1 =
      'assets/documents/Grade6Quarter2Lesson1.pdf';
  static const grade6quarter2Lesson2 =
      'assets/documents/Grade6Quarter2Lesson2.pdf';
  static const grade6quarter2Lesson3 =
      'assets/documents/Grade6Quarter2Lesson3.pdf';
  static const grade6quarter3Lesson1 =
      'assets/documents/Grade6Quarter3Lesson1.pdf';
  static const grade6quarter3Lesson2 =
      'assets/documents/Grade6Quarter3Lesson2.pdf';
}

class StorageFields {
  static const verificationImages = 'verificationImages';
  static const profilePics = 'profilePics';
}

class Collections {
  static const String users = 'users';
  static const String sections = 'sections';
  static const String faqs = 'faqs';
  static const String modules = 'modules';
  static const String quizzes = 'quizzes';
  static const String quizResults = 'quizResults';
  static const String speechResults = 'speechResults';
}

class UserTypes {
  static const String student = 'STUDENT';
  static const String teacher = 'TEACHER';
  static const String admin = 'ADMIN';
}

class UserFields {
  static const String email = 'email';
  static const String password = 'password';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String userType = 'userType';
  static const String profileImageURL = 'profileImageURL';
  static const String isVerified = 'isVerified';
  static const String birthDate = 'birthDate';
  static const String contactNumber = 'contactNumber';
  static const String assignedSections = 'assignedSections';
  static const String idNumber = 'idNumber';
  static const String verificationImage = 'verificationImage';
  static const String moduleProgresses = 'moduleProgresses';
  static const String gradeLevel = 'gradeLevel';
  static const String speechIndex = 'speechIndex';
}

class SectionFields {
  static const String name = 'name';
  static const String teacherIDs = 'teacherIDs';
  static const String studentIDs = 'studentIDs';
}

class ModuleFields {
  static const String teacherID = 'teacherID';
  static const String sectionID = 'sectionID';
  static const String title = 'title';
  static const String content = 'content';
  static const String dateCreated = 'dateCreated';
  static const String dateLastModified = 'dateLastModified';
  static const String additionalDocuments = 'additionalDocuments';
  static const String additionalResources = 'additionalResources';
  static const String quarter = 'quarter';
  static const String gradeLevel = 'gradeLevel';
}

class ModuleProgressFields {
  static const String quarter = 'quarter';
  static const String title = 'title';
  static const String progress = 'progress';
}

class AdditionalResourcesFields {
  static const String fileName = 'fileName';
  static const String downloadLink = 'downloadLink';
}

class QuizFields {
  static const String isGlobal = 'isGlobal';
  static const String isActive = 'isActive';
  static const String teacherID = 'teacherID';
  static const String quizType = 'quizType';
  static const String title = 'title';
  static const String questions = 'questions';
  static const String dateCreated = 'dateCreated';
  static const String dateLastModified = 'dateLastModified';
  static const String gradeLevel = 'gradeLevel';
}

class QuestionFields {
  static const String question = 'question';
  static const String options = 'options';
  static const String answer = 'answer';
}

class QuizTypes {
  static const String multipleChoice = 'MULTIPLE-CHOICE';
  static const String trueOrFalse = 'TRUE-FALSE';
  static const String identification = 'IDENTIFICATION';
}

class QuizResultFields {
  static const String studentID = 'studentID';
  static const String quizID = 'quizID';
  static const String answers = 'answers';
  static const String grade = 'grade';
}

class SpeechResultFields {
  static const String studentID = 'studentID';
  static const String speechIndex = 'speechIndex';
  static const String speechResults = 'speechResults';
}

class SpeechFields {
  static const String breakdown = 'breakdown';
  static const String similarity = 'similarity';
  static const String confidence = 'confidence';
  static const String average = 'average';
}

class PathParamters {
  static const sectionID = 'sectionID';
  static const userID = 'userID';
}

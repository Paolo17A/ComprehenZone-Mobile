class ImagePaths {
  static const comprehenzoneLogo = 'assets/images/COMPREHENZONE LOGO.png';
  static const loginBG = 'assets/images/BG WALLPAPER.png';
  static const frontPageLogo = 'assets/images/logo frontpage.png';
  static const homeBG = 'assets/images/FIRST PAGE OPTIONS BG.jpg';
  static const homeBook = 'assets/images/home book.png';
  static const homeStudying = 'assets/images/studying.png';
  static const homeFeedback = 'assets/images/feedback.png';
  static const research = 'assets/images/research.png';
  static const drawerHome = 'assets/images/home.png';
  static const drawerProfile = 'assets/images/user.png';
  static const profileBG = 'assets/images/PROFILE PAGE.jpg';
  static const profileUser = 'assets/images/profile-user.png';
  static const profileDateOfBirth = 'assets/images/date-of-birth.png';
  static const profileContactNumber = 'assets/images/mobile.png';
  static const profileID = 'assets/images/personal-id.png';
  static const defaultProfilePic = 'assets/images/student.png';
  static const modulesBG = 'assets/images/LEARNING MATERIALS BG.jpg';
  static const quarterBooks = 'assets/images/books.png';
  static const quarterEasyToUse = 'assets/images/easy-to-use.png';
  static const quarterIdea = 'assets/images/idea.png';
  static const quarterReading = 'assets/images/reading-book 1.png';
  static const quizGB = 'assets/images/QUIZZES AND EXAM BG.jpg';
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
  static const String assignedSection = 'assignedSection';
  static const String idNumber = 'idNumber';
  static const String verificationImage = 'verificationImage';
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
}

class AdditionalResourcesFields {
  static const String fileName = 'fileName';
  static const String downloadLink = 'downloadLink';
}

class QuizFields {
  static const String teacherID = 'teacherID';
  static const String sectionID = 'sectionID';
  static const String quizType = 'quizType';
  static const String title = 'title';
  static const String questions = 'questions';
  static const String dateCreated = 'dateCreated';
  static const String dateLastModified = 'dateLastModified';
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

class PathParamters {
  static const sectionID = 'sectionID';
  static const userID = 'userID';
}

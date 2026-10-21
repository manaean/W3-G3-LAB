import '../model/courseResult.dart';

import '../model/course.dart';
import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List<Course> courses = [];
  final List<CourseResult> results = [];
  int _nextResultId = 1;

  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    if (_findStudentOrNull(studentId) != null) {
      throw Exception('Student $studentId already exists');
    }
    students.add(Student(id: studentId, name: studentName));
  }

  void removeStudent({required String studentId}) {
    if (_findStudentOrNull(studentId) == null) {
      throw Exception('Student $studentId not found');
    }
    // 1- Remove student from the students list
    students.removeWhere((s) => s.id == studentId);
    for (final course in courses) {
      course.studentIds.remove(studentId);
    }
    results.removeWhere((r) => r.studentId == studentId);
  }

  // ---------------- courses ----------------

  void addCourse({required String courseId, required String courseName}) {
    // ! Course ID shall be unique
    if (_findCourseOrNull(courseId) != null) {
      throw Exception('Course $courseId already exists');
    }
    courses.add(Course(id: courseId, name: courseName));
  }

  void removeCourse({required String courseId}) {
    if (_findCourseOrNull(courseId) == null) {
      throw Exception('Course $courseId not found');
    }
    results.removeWhere((r) => r.courseId == courseId);
    courses.removeWhere((c) => c.id == courseId);
  }

  // ---------------- enrollment ----------------

  void addStudentToCourse({
    required String studentId,
    required String courseId,
  }) {
    if (_findStudentOrNull(studentId) == null) {
      throw Exception('Student $studentId not found');
    }
    final course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId already enrolled in $courseId');
    }
    course.studentIds.add(studentId);
  }

  void removeStudentFromCourse({
    required String studentId,
    required String courseId,
  }) {
    if (_findStudentOrNull(studentId) == null) {
      throw Exception('Student $studentId not found');
    }
    final course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in $courseId');
    }
    course.studentIds.remove(studentId);
    results.removeWhere(
      (r) => r.studentId == studentId && r.courseId == courseId,
    );
  }

  String addScore({
    required String studentId,
    required String courseId,
    required int score,
  }) {
    if (_findStudentOrNull(studentId) == null) {
      throw Exception('Student $studentId not found');
    }
    final course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in $courseId');
    }
    if (score < 0 || score > 100) {
      throw Exception('Score must be between 0 and 100');
    }
    final duplicate = results.any(
      (r) => r.studentId == studentId && r.courseId == courseId,
    );
    if (duplicate) {
      throw Exception('Student $studentId already has a result in $courseId');
    }
    final id = 'R${_nextResultId++}';
    results.add(CourseResult(
      id: id,
      studentId: studentId,
      courseId: courseId,
      score: score,
    ));
    return id;
  }

  void removeResult({required String resultId}) {
    final before = results.length;
    results.removeWhere((r) => r.id == resultId);
    if (results.length == before) {
      throw Exception('Result $resultId not found');
    }
  }

  bool isEnrolled({required String studentId, required String courseId}) =>
      _findCourseOrNull(courseId)?.studentIds.contains(studentId) ?? false;

  List<CourseResult> resultsOfStudent({required String studentId}) =>
      results.where((r) => r.studentId == studentId).toList();

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null;
  }

  Course? _findCourseOrNull(String courseId) {
    for (Course c in courses) {
      if (c.id == courseId) {
        return c;
      }
    }
    return null;
  }

  getStudentsInCourse(String s) {}

  getScore({required String studentId, required String courseId}) {}
}

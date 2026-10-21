import 'package:lms_layered_architecture_example/model/student.dart';
import 'package:test/test.dart';

import '../service/lms_system.dart';

void main() {
  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  
  });

  test('creates a course', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(lms.courses.length, 1);
  });

  test('add a student to a course', () {
    final lms = LmsSystem();

    lms.addStudentToCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.getStudentsInCourse('C1'), contains('S1'));
  });

  test('add a score for a student and a course', () {
  final lms = LmsSystem();

  lms.addStudent(studentId: 'S01', studentName: '');
  lms.addCourse(
    courseId: 'C01',
    courseName: 'Mobile Development',
  );

  lms.addStudentToCourse(
    studentId: 'S01',
    courseId: 'C01',
  );

  lms.addScore(
    studentId: 'S01',
    courseId: 'C01',
    score: 85,
  );

  expect(
    lms.getScore(studentId: 'S01', courseId: 'C01'),
    equals(85),
  );
});

test('remove a student from the LMS', () {
  final lms = LmsSystem();

  lms.addStudent(studentId: 'S1', studentName: '');
  lms.addStudent(studentId: 'S2', studentName: '');

  lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
  lms.addCourse(courseId: 'C2', courseName: 'Flutter Development');

  lms.addStudentToCourse(studentId: 'S1', courseId: 'C1');
  lms.addStudentToCourse(studentId: 'S1', courseId: 'C2');
  lms.addStudentToCourse(studentId: 'S2', courseId: 'C1');

  lms.addScore(studentId: 'S1', courseId: 'C1', score: 85);
  lms.addScore(studentId: 'S1', courseId: 'C2', score: 90);
  lms.addScore(studentId: 'S2', courseId: 'C1', score: 75);

  lms.removeStudent(studentId: 'S01');

  // Student is removed from the global student list
  expect(lms.students.containsKey('S01'), isFalse);

  // Student is removed from every course
  expect(lms.courses['C1']!.studentIds, isNot(contains('S1')));
  expect(lms.courses['C22']!.studentIds, isNot(contains('S1')));

  // All results belonging to the student are removed
  expect(lms.getScore(studentId: 'S1', courseId: 'C1'), isNull);
  expect(lms.getScore(studentId: 'S1', courseId: 'C2'), isNull);

  // Other students and their results remain unchanged
  expect(lms.students.containsKey('S2'), isTrue);
  expect(lms.getScore(studentId: 'S2', courseId: 'C1'), equals(75));
});


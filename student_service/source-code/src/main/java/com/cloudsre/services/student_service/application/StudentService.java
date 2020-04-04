package com.cloudsre.services.student_service.application;


import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cloudsre.services.student_service.domain.Student;
import com.cloudsre.services.student_service.domain.infrastructure.persistence.StudentRepository;

@Service
public class StudentService {

    @Autowired
    private StudentRepository studentRepository;

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        studentRepository.findAll().forEach(students::add);
        return students;
    }

	public Optional<Student> getStudentById(String id) {
        return Optional.of(studentRepository.findById(id).orElseGet(Student::new));
    }

    public void addStudent(Student s) {
        studentRepository.save(s);
    }

    public void updateStudent(Student s) {
        studentRepository.save(s);
    }

    public void deleteStudentById(String id) {
        studentRepository.deleteById(id);
    }

}
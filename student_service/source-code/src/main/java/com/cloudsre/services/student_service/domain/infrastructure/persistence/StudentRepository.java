package com.cloudsre.services.student_service.domain.infrastructure.persistence;

import org.springframework.stereotype.Repository;

import com.cloudsre.services.student_service.domain.Student;

import org.springframework.data.repository.CrudRepository;

@Repository
public interface StudentRepository extends CrudRepository<Student,String>{

}

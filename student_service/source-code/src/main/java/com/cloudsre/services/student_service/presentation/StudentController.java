package com.cloudsre.services.student_service.presentation;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.cloudsre.services.student_service.application.StudentService;
import com.cloudsre.services.student_service.domain.Student;
import com.cloudsre.services.student_service.exception.StudentNotFoundAdvice;
import com.cloudsre.services.student_service.exception.StudentNotFoundException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
public class StudentController {
	
	@Autowired
	private StudentService studentService;
	
	private static final Logger logger = LoggerFactory.getLogger(StudentController.class);

	
	
	@GetMapping("/students")
    public List<Student> getAllBooks() {
		logger.info(this.getClass().getSimpleName() + " - Get all Students service is invoked.");
        return studentService.getAllStudents();
    }

    @GetMapping("/students/{id}")
    public Student getStudent(@PathVariable String id) throws StudentNotFoundException{
    	logger.info(this.getClass().getSimpleName() + " - Get students details by id is invoked.");
    	
    	Optional<Student> student = studentService.getStudentById(id);
        if(!student.isPresent())
            throw new StudentNotFoundException(id);
 
        return student.get();
        
        //return studentService.getStudent(studentId);
    }

    @PostMapping("/students")
    public void addStudent(@RequestBody Student student) throws Exception{
    	logger.info(this.getClass().getSimpleName() + " - Create new student method is invoked.");
    	
    	if(student.getId() == null || student.getId().isEmpty())
    		throw new Exception("Empty StudentId is not allowed");
    	
        studentService.addStudent(student);
    	
        
    }

    @PutMapping("/students/{id}")
    public void updateStudent(@PathVariable String id, @RequestBody Student updatetudobj) throws Exception{
    	logger.info(this.getClass().getSimpleName() + " - Update student details by id is invoked.");
    	 
    	Optional<Student> student = studentService.getStudentById(id);
        if(!student.isPresent())
            throw new Exception("Could not find student with id- " + id);
        
        
        /*To prevent overriding of existing values of variables*/
        if(updatetudobj.getFirstName() == null || updatetudobj.getFirstName().isEmpty())
        	updatetudobj.setFirstName(student.get().getFirstName());
        if(updatetudobj.getLastName() == null || updatetudobj.getLastName().isEmpty())
        	updatetudobj.setLastName(student.get().getLastName());
        if(updatetudobj.getGrade() == null || updatetudobj.getGrade().isEmpty())
        	updatetudobj.setGrade(student.get().getGrade());
        if(updatetudobj.getNationality() == null || updatetudobj.getNationality().isEmpty())
        	updatetudobj.setNationality(student.get().getNationality());
       
        
        // Required for the "where" clause in the sql query template.
        
        updatetudobj.setId(id);
        
        studentService.updateStudent(updatetudobj);
    }

    @DeleteMapping("/students/{id}")
    public void deleteStudent(@PathVariable String studentId) throws Exception {
    	logger.info(this.getClass().getSimpleName() + " - Delete student by id is invoked.");
    	
    	Optional<Student> student = studentService.getStudentById(studentId);
        if(!student.isPresent())
            throw new Exception("Could not find student with id- " + studentId);
    	 
        studentService.deleteStudentById(studentId);
    }

}

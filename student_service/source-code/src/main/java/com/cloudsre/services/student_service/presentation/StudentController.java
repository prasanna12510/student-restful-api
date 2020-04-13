package com.cloudsre.services.student_service.presentation;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import com.cloudsre.services.student_service.application.StudentService;
import com.cloudsre.services.student_service.domain.Student;
import com.cloudsre.services.student_service.exception.StudentNotFoundException;
import io.swagger.annotations.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@Api(value="Student Management System", description = "CRUD operations for Student Portal")
public class StudentController {
	
	@Autowired
	private StudentService studentService;
	
	private static final Logger logger = LoggerFactory.getLogger(StudentController.class);

	@ApiOperation(value = "Health check for all students", response = String.class)
	@GetMapping("/students/health")
    public ResponseEntity<String> health() {
		HttpHeaders responseHeaders = new HttpHeaders();
	    responseHeaders.setContentType(MediaType.APPLICATION_JSON);
	    return ResponseEntity.ok()
	      .headers(responseHeaders)
	      .body("{\"status\":\"All Students are healthy and OK shashank is live!!!\"}");
    }
	
	@ApiOperation(value = "View a list of available student", response = List.class)
	@ApiResponses(value = {
		    @ApiResponse(code = 200, message = "Successfully retrieved list"),
		    @ApiResponse(code = 404, message = "The resource you were trying to reach is not found")
		})
	@GetMapping("/students")
    public ResponseEntity<List<Student>> getAllStudents() {
		logger.info(this.getClass().getSimpleName() + " - Get all Students service is invoked.");
        return ResponseEntity.ok(studentService.getAllStudents());
        
    }

	@ApiOperation(value = "Get student by Id")
    @GetMapping("/students/{id}")
    public ResponseEntity<Student> getStudent(@ApiParam(value = "Student id from which student object will retrieve", required = true) @PathVariable String id) throws StudentNotFoundException{
    	logger.info(this.getClass().getSimpleName() + " - Get students details by id is invoked.");
    	
    	Optional<Student> student = studentService.getStudentById(id);
        if(!student.isPresent())
            throw new StudentNotFoundException(id);
 
        return ResponseEntity.ok(student.get());
    }

    @ApiOperation(value = "Add new student details")
    @PostMapping("/students")
    public Student addStudent(@ApiParam(value = "Student object store in database table", required = true) @Valid @RequestBody Student student) throws Exception{
    	logger.info(this.getClass().getSimpleName() + " - Create new student method is invoked.");
    	
    	if(student.getId() == null || student.getId().isEmpty())
    		throw new Exception("Empty StudentId is not allowed");
    	
        Student s =studentService.addStudent(student);	
        return s;
        
     }
    
    
    @ApiOperation(value = "Update existing student details based on Id")
    @PutMapping("/students/{id}")
    public void updateStudent(@ApiParam(value = "Student Id to update student object", required = true) @PathVariable String id, 
    		 @ApiParam(value = "Update student object", required = true) @Valid @RequestBody Student updatestudobj) throws StudentNotFoundException{
    	logger.info(this.getClass().getSimpleName() + " - Update student details by id is invoked.");
    	 
    	Optional<Student> student = studentService.getStudentById(id);
        if(!student.isPresent())
        	throw new StudentNotFoundException(id);
        
        
        /*To prevent overriding of existing values of variables*/
        if(updatestudobj.getFirstName() == null || updatestudobj.getFirstName().isEmpty())
        	updatestudobj.setFirstName(student.get().getFirstName());
        if(updatestudobj.getLastName() == null || updatestudobj.getLastName().isEmpty())
        	updatestudobj.setLastName(student.get().getLastName());
        if(updatestudobj.getGrade() == null || updatestudobj.getGrade().isEmpty())
        	updatestudobj.setGrade(student.get().getGrade());
        if(updatestudobj.getNationality() == null || updatestudobj.getNationality().isEmpty())
        	updatestudobj.setNationality(student.get().getNationality());
       
        
        // Required for the "where" clause in the SQL query template.
        updatestudobj.setId(id);
        
        studentService.updateStudent(updatestudobj);
        
        logger.info(this.getClass().getSimpleName() + " student " + id+ "updated successfully");
    }
    
    @ApiOperation(value = "Delete student by Id")
    @DeleteMapping("/students/{id}")
    public Map<String, Boolean> deleteStudent(@ApiParam(value = "Student Id from which student object will delete from database table", required = true) @PathVariable String id) throws StudentNotFoundException {
    	logger.info(this.getClass().getSimpleName() + " - Delete student by id is invoked.");
    	
    	Optional<Student> student = studentService.getStudentById(id);
        if(!student.isPresent())
            throw new StudentNotFoundException(id);
    	 
        studentService.deleteStudentById(id);
        logger.info(this.getClass().getSimpleName() + " student " + id+ "deleted successfully");
        Map<String, Boolean> response = new HashMap<>();
        response.put("deleted", Boolean.TRUE);
        return response;
        
    }

}

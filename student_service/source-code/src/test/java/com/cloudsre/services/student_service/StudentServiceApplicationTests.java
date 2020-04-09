package com.cloudsre.services.student_service;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.web.client.HttpClientErrorException;

import com.cloudsre.services.student_service.domain.Student;



@RunWith(SpringRunner.class)
@SpringBootTest(classes = StudentServiceApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class StudentServiceApplicationTests {

	@Autowired
	private TestRestTemplate restTemplate;

	@LocalServerPort
	private int port;

	private String getRootUrl() {
		return "http://localhost:" + port;
	}

	@Test
	public void contextLoads() {

	}

	@Test
	public void testGetAllStudents() {
		HttpHeaders headers = new HttpHeaders();
		HttpEntity<String> entity = new HttpEntity<String>(null, headers);

		ResponseEntity<String> response = restTemplate.exchange(getRootUrl() + "/students",
				HttpMethod.GET, entity, String.class);
		
		assertNotNull(response.getBody());
	}

	@Test
	public void testGetStudentById() {
		Student student = restTemplate.getForObject(getRootUrl() + "/students/1", Student.class);
		System.out.println(student.getFirstName());
		assertNotNull(student);
	}

	@Test
	public void testAddStudent() {
		Student student = new Student();
		student.setFirstName("prasanna");
		student.setLastName("pawar");
		student.setGrade("A");
		student.setId("123");
		student.setNationality("India");
		

		ResponseEntity<Student> postResponse = restTemplate.postForEntity(getRootUrl() + "/students", student, Student.class);
		assertNotNull(postResponse);
		assertNotNull(postResponse.getBody());
	}

	@Test
	public void testUpdateStudent() {
		int id = 123;
		Student student = restTemplate.getForObject(getRootUrl() + "/students/" + id, Student.class);
		student.setFirstName("aaron");
		student.setLastName("Swartz");

		restTemplate.put(getRootUrl() + "/students/" + id, student);

		Student updatedStudent = restTemplate.getForObject(getRootUrl() + "/students/" + id, Student.class);
		assertNotNull(updatedStudent);
	}

	@Test
	public void testDeleteStudent() {
		int id = 123;
		Student student = restTemplate.getForObject(getRootUrl() + "/students/" + id, Student.class);
		assertNotNull(student);

		restTemplate.delete(getRootUrl() + "/students/" + id);

		try {
			student = restTemplate.getForObject(getRootUrl() + "/students/" + id, Student.class);
		} catch (final HttpClientErrorException e) {
			assertEquals(e.getStatusCode(), HttpStatus.NOT_FOUND);
		}
	}

}
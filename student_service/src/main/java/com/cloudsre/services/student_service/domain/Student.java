package com.cloudsre.services.student_service.domain;

import javax.persistence.Entity;
import javax.persistence.Id;



@Entity
public class Student {
	
	@Id
	private String id = "";
	private String firstName = "";
	private String lastName = "";
	private String grade = "";
	private String nationality = "";
	
	public Student() {
		// TODO Auto-generated constructor stub
	}

	public Student(String id, String firstName, String lastName, String grade, String nationality) {
		super();
		this.id = id;
		this.firstName = firstName;
		this.lastName = lastName;
		this.grade = grade;
		this.nationality = nationality;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getNationality() {
		return nationality;
	}

	public void setNationality(String nationality) {
		this.nationality = nationality;
	}	

}

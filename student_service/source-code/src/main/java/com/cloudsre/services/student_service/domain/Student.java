package com.cloudsre.services.student_service.domain;

import javax.persistence.Entity;
import javax.persistence.Id;
import io.swagger.annotations.*;


@Entity
@ApiModel(description = "All details about the Students. ")
public class Student {
	
	@Id
	@ApiModelProperty(notes = "The database generated student ID")
	private String id = "";
	@ApiModelProperty(notes = "The Student firstname")
	private String firstName = "";
	@ApiModelProperty(notes = "The Student lastname")
	private String lastName = "";
	@ApiModelProperty(notes = "The Student grade")
	private String grade = "";
	@ApiModelProperty(notes = "The Student nationality")
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

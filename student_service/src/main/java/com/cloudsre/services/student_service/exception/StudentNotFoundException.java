package com.cloudsre.services.student_service.exception;

public class StudentNotFoundException extends RuntimeException {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public StudentNotFoundException(String id) {
	    super("Could not find student " + id);
	  }

}

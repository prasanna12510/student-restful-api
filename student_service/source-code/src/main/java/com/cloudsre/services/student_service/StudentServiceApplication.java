package com.cloudsre.services.student_service;

import org.springframework.boot.SpringApplication;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class StudentServiceApplication {
	
	private static final Logger logger = LoggerFactory.getLogger(StudentServiceApplication.class);

	public static void main(String[] args) {
		logger.info("\n----Begin logging StudentServiceApplication----");
		
		SpringApplication.run(StudentServiceApplication.class, args);
		
		logger.info("----End logging StudentServiceApplication----");
		
	}

}

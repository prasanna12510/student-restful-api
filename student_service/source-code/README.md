# Spring Boot Application for Student-API Portal
student-api using spring boot
automated deployment of infrastructure (networking,monitoring,config management) using Terraform   

## Built With

* 	[Maven](https://maven.apache.org/) - Dependency Management
* 	[JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) - Java™ Platform, Standard Edition Development Kit
* 	[Spring Boot](https://spring.io/projects/spring-boot) - Framework to ease the bootstrapping and development of new Spring Applications
* 	[Swagger](https://swagger.io/) - Open-Source software framework backed by a large ecosystem of tools that helps developers design, build, document, and consume RESTful Web services.

## External Tools Used

* [Postman](https://www.getpostman.com/) - API Development Environment (Testing Docmentation)


## Running the application locally

There are several ways to run a Spring Boot application on your local machine. One way is to execute the `main` method in the `com.cloudsre.services.student_service` class from your IDE.

- Download the zip or clone the Git repository.
- Unzip the zip file (if you downloaded one)
- Open Command Prompt and Change directory (cd) to folder containing pom.xml
- Open Eclipse
   - File -> Import -> Existing Maven Project -> Navigate to the folder where you unzipped the zip
   - Select the project
- Choose the Spring Boot Application file (search for @SpringBootApplication)
- Right Click on the file and Run as Java Application

Alternatively you can use the [Spring Boot Maven plugin](https://docs.spring.io/spring-boot/docs/current/reference/html/build-tool-plugins-maven-plugin.html) like so:

```shell
mvn spring-boot:run
```
build and test with docker locally
```shell
mvn dockerfile:build install
```

### Actuator

To monitor and manage your application

|  URL |  Method |
|----------|--------------|
|`http://localhost:8080`  						| GET |
|`http://localhost:8080/actuator/`             | GET |
|`http://localhost:8080/actuator/health`    	| GET |
|`http://localhost:8080/actuator/info`      	| GET |
|`http://localhost:8080/actuator/prometheus`| GET |
|`http://localhost:8080/actuator/httptrace` | GET |


### Student API URLs

|  URL |  Method | Remarks |
|----------|--------------|--------------|
|`http://localhost:8080/students/health`                           | GET | Header `Accept:application/json`
|`http://localhost:8080/students/1`                                | GET | |
|`http://localhost:8080/students/1`                                | PUT | |
|`http://localhost:8080/students`                                  | POST| |
|`http://localhost:8080/students/1`                                | DELETE | |


## Documentation
* [Swagger](http://localhost:8088/swagger-ui.html) - Documentation & Testing
![Alt text](https://github.com/prasanna12510/student-restful-api/blob/master/doc/img/swagger-ui-docs.png?raw=true "swagger-ui-docs")



## packages

- `application` — to communicate with the database;
- `domain` — to hold our entities;
- `domain.infrastructure` — repository
- `exception` — security configuration;
- `presentation` — to hold our business logic;

- `resources/` - Contains all the static resources, templates and property files.
- `resources/application.properties` - It contains application-wide properties. Spring reads the properties defined in this file to configure your application. You can define server’s default port, server’s context path, database URLs etc, in this file.


- `pom.xml` - contains all the project dependencies

//
//  SignupValidatorTest.swift
//  MusicAppTests
//
//  Created by Steve on 26/06/2023.
//

import XCTest
@testable import MusicApp

final class SignupValidatorTest: XCTestCase {
    
    private var validator: SignupValidator!
    
    private var dobValid, dobInvalid: Date!
    
    override func setUp() {
        validator = SignupValidator()
        dobValid = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        dobInvalid = Calendar.current.date(byAdding: .year, value: -12, to: Date())
    }
    
    override func tearDown() {
        validator = nil
    }
    
    func test_with_empty_person_first_name_error_thrown() {
        let newStudent = NewStudent()
        XCTAssertThrowsError(try validator.validate(newStudent), "Error for empty first name should be thrown")
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            guard let validationError = error as? SignupValidator.NewUserValidatorError else {
                XCTFail("Got the wrong type of error, expecting a new user validator error")
                return
            }
            
            XCTAssertEqual(validationError, SignupValidator.NewUserValidatorError.invalidFirstName, "Expecting an error where we have an invalid first name")
        }
    }
    
    func test_with_empty_first_name_error_thrown() {
        let newStudent = NewStudent(lastName: "Test", email: "Test@test", password: "test", inputDob: dobValid, tos: true)
        XCTAssertThrowsError(try validator.validate(newStudent), "Error for empty first name should be thrown")
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            guard let validationError = error as? SignupValidator.NewUserValidatorError else {
                XCTFail("Got the wrong type of error, expecting a new user validator error")
                return
            }
            
            XCTAssertEqual(validationError, SignupValidator.NewUserValidatorError.invalidFirstName, "Expecting an error where we have an invalid first name")
        }
    }
    
    func test_with_empty_last_name_error_thrown() {
        let newStudent = NewStudent(firstName: "Test", email: "Test@test", password: "test", inputDob: dobValid, tos: true)
        XCTAssertThrowsError(try validator.validate(newStudent), "Error for empty last name should be thrown")
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            guard let validationError = error as? SignupValidator.NewUserValidatorError else {
                XCTFail("Got the wrong type of error, expecting a new user validator error")
                return
            }
            
            XCTAssertEqual(validationError, SignupValidator.NewUserValidatorError.invalidLastName, "Expecting an error where we have an invalid last name")
        }
    }
    
    func test_with_empty_email_error_thrown() {
        let newStudent = NewStudent(firstName: "Test", lastName: "Test", password: "test", inputDob: dobValid, tos: true)
        XCTAssertThrowsError(try validator.validate(newStudent), "Error for empty email should be thrown")
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            guard let validationError = error as? SignupValidator.NewUserValidatorError else {
                XCTFail("Got the wrong type of error, expecting a new user validator error")
                return
            }
            
            XCTAssertEqual(validationError, SignupValidator.NewUserValidatorError.invalidEmail, "Expecting an error where we have an invalid email")
        }
    }
    
    func test_with_empty_password_error_thrown() {
        let newStudent = NewStudent(firstName: "Test", lastName: "Test", email: "test@test.com", inputDob: dobValid, tos: true)
        XCTAssertThrowsError(try validator.validate(newStudent), "Error for empty password should be thrown")
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            guard let validationError = error as? SignupValidator.NewUserValidatorError else {
                XCTFail("Got the wrong type of error, expecting a new user validator error")
                return
            }
            
            XCTAssertEqual(validationError, SignupValidator.NewUserValidatorError.invalidPassword, "Expecting an error where we have an invalid password")
        }
    }
    
    func test_with_invalid_dob_error_thrown() {
        let newStudent = NewStudent(firstName: "Test", lastName: "Test", email: "test@test.com", password: "test", inputDob: dobInvalid, tos: true)
        XCTAssertThrowsError(try validator.validate(newStudent), "Error for invalid dob should be thrown")
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            guard let validationError = error as? SignupValidator.NewUserValidatorError else {
                XCTFail("Got the wrong type of error, expecting a new user validator error")
                return
            }
            
            XCTAssertEqual(validationError, SignupValidator.NewUserValidatorError.invalidDob(ageLimt: 13), "Expecting an error where we have an invalid dob")
        }
    }
    
    func test_with_invalid_tos_error_thrown() {
        let newStudent = NewStudent(firstName: "Test", lastName: "Test", email: "test@test.com", password: "test", inputDob: dobValid)
        XCTAssertThrowsError(try validator.validate(newStudent), "Error for invalid tos should be thrown")
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            guard let validationError = error as? SignupValidator.NewUserValidatorError else {
                XCTFail("Got the wrong type of error, expecting a new user validator error")
                return
            }
            
            XCTAssertEqual(validationError, SignupValidator.NewUserValidatorError.invalidTos, "Expecting an error where we have an invalid tos")
        }
    }
    
    
    func test_with_valid_person_error_not_thrown() {
        let newStudent = NewStudent(firstName: "test", lastName: "test", email: "email", password: "test", inputDob: dobValid, tos: true)
        
        do {
            _ = try validator.validate(newStudent)
        } catch {
            XCTFail("No errors should be thrown, since the person should be a valid object")
        }
    }
    
}

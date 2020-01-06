package com.adrenadev.tutorial.main.controller

import com.adrenadev.tutorial.main.model.User
import com.adrenadev.tutorial.main.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import javax.validation.Valid

@RestController
@RequestMapping("/api")
@Suppress("UNUSED")
class UserController(@Autowired private val mUserRepository: UserRepository) {

    @PostMapping("/users")
    fun createUser(@Valid @RequestBody user: User): User = mUserRepository.save(user)

    @GetMapping("/users")
    fun getAllUsers(): List<User> = mUserRepository.findAll()

    @GetMapping("/users/{userId}")
    fun getUserById(@PathVariable userId: Long): ResponseEntity<User> =
            mUserRepository.findById(userId)
            .map { ResponseEntity.ok(it) }
            .orElse(ResponseEntity.notFound().build())

    @PutMapping("/users/{userId}")
    fun updateUser(@PathVariable userId: Long, @RequestBody updatedUser: User): ResponseEntity<User> =
            mUserRepository.findById(userId).map {
            val newUser = it.copy(name = updatedUser.name, phone = updatedUser.phone)
            ResponseEntity.ok().body(createUser(newUser))
        }.orElse(ResponseEntity.notFound().build())

    @DeleteMapping("/users/{userId}")
    fun deleteUser(@PathVariable userId: Long): ResponseEntity<Void> =
        mUserRepository.findById(userId).map {
            mUserRepository.delete(it)
            ResponseEntity<Void>(HttpStatus.OK)
        }.orElse(ResponseEntity.notFound().build())

}
package com.adrenadev.tutorial.main.repository

import com.adrenadev.tutorial.main.model.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserRepository: JpaRepository<User, Long>
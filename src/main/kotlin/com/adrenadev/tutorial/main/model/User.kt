package com.adrenadev.tutorial.main.model

import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.validation.constraints.NotBlank

@Entity(name = "users")
data class User(
        @Id @GeneratedValue(strategy = GenerationType.IDENTITY) val id: Long = 0,
        @get: NotBlank val name: String = "",
        @get: NotBlank val phone: String = "")
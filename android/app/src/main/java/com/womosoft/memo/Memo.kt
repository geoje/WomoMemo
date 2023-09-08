package com.womosoft.memo

data class Memo(
    val title: String = "",
    val content: String = "",
    val color: String = "white",
    val archive: Boolean = false,
    val checked: String?,
    val deleted: String?
)
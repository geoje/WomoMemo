package com.womosoft.memo

import android.annotation.SuppressLint
import android.content.Context

data class Memo(
    val title: String = "",
    val content: String = "",
    val color: String = "white",
    val archive: Boolean = false,
    val checked: String?,
    val deleted: String?
) {
    @SuppressLint("DiscouragedApi")
    fun backgroundColor(context: Context): Int {
        val resId = context.resources.getIdentifier(
            if (color == "clear") "white_1000" else camelToSnake(color) + "_50",
            "color",
            context.packageName
        )
        return context.resources.getColor(resId, context.theme)
    }
    @SuppressLint("DiscouragedApi")
    fun borderColor(context: Context): Int {
        val resId = context.resources.getIdentifier(
            if (color == "clear") "grey_300" else camelToSnake(color) + "_100",
            "color",
            context.packageName
        )
        return context.resources.getColor(resId, context.theme)
    }
    private fun camelToSnake(str: String): String {
        for (i in str.length - 1 downTo 0) {
            if (Character.isUpperCase(str[i])) {
                return "${str.substring(0, i)}_${str[i].lowercase()}${str.substring(i)}"
            }
        }
        return str
    }
}
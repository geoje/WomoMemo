package com.womosoft.memo

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log

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
        return try {
            context.resources.getColor(resId, context.theme)
        } catch(ex: Exception) {
            context.resources.getColor(R.color.white_1000, context.theme)
        }
    }
    @SuppressLint("DiscouragedApi")
    fun borderColor(context: Context): Int {
        val resId = context.resources.getIdentifier(
            if (color == "clear") "grey_300" else camelToSnake(color) + "_100",
            "color",
            context.packageName
        )
        return try {
            context.resources.getColor(resId, context.theme)
        } catch(ex: Exception) {
            context.resources.getColor(R.color.green_300, context.theme)
        }
    }
    private fun camelToSnake(str: String): String {
        for (i in str.length - 1 downTo 0) {
            if (Character.isUpperCase(str[i])) {
                return "${str.substring(0, i)}_${str[i].lowercase()}${str.substring(i+1)}"
            }
        }
        return str
    }
}
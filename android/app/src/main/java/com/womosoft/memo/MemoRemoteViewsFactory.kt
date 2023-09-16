package com.womosoft.memo

import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.HomeWidgetPlugin

class MemoRemoteViewsFactory(
    private val context: Context
) : RemoteViewsService.RemoteViewsFactory {
    private val gson = Gson()
    private lateinit var memos: Map<String, Memo>

    override fun onCreate() {}

    override fun onDataSetChanged() {
        val widgetData = HomeWidgetPlugin.getData(context)
        val memosJson = widgetData.getString("memosJson", "{}") ?: "{}"
        val type = object : TypeToken<Map<String, Memo>>() {}.type
        memos = gson.fromJson(memosJson, type)
    }

    override fun onDestroy() {}

    override fun getCount(): Int = memos.size

    override fun getViewAt(position: Int): RemoteViews {
        val key: String = memos.keys.toList()[position]
        val memo = memos[key]!!

        return RemoteViews(context.packageName, R.layout.memo_list_item).apply {
            // Title
            setTextViewText(R.id.txtTitle, memo.title)
            setViewVisibility(R.id.txtTitle, if (memo.title.isEmpty()) View.GONE else View.VISIBLE)

            // Divider
            setViewVisibility(R.id.txtDivider, if (memo.content.isEmpty() || memo.title.isEmpty()) View.GONE else View.VISIBLE)

            // Content
            if (memo.checked == null) setTextViewText(R.id.txtContent, memo.content)
            else {
                val checked = try {
                    memo.checked.split(",").map { it.toInt() }.toSet()
                } catch (ex: Exception) {
                    HashSet()
                }
                val content = memo.content.lines()
                    .foldIndexed("") { index, acc, s -> "$acc\n${if (checked.contains(index)) "☑" else "☐"} $s" }
                setTextViewText(R.id.txtContent, content)
            }
            setViewVisibility(R.id.txtContent, if (memo.content.isEmpty() && memo.title.isNotEmpty()) View.GONE else View.VISIBLE)

            // Background
            setInt(R.id.imgBackground, "setColorFilter", memo.backgroundColor(context))

            // Click to launch
            val fillInIntent = Intent().apply {
                putExtra("key", key)
            }
            setOnClickFillInIntent(R.id.txtContent, fillInIntent)
        }
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
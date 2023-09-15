package com.womosoft.memo

import android.content.Context
import android.util.Log
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

        Log.v("[Factory memosJson]", memosJson)
    }

    override fun onDestroy() {}

    override fun getCount(): Int = memos.size

    override fun getViewAt(position: Int): RemoteViews {
        val key: String = memos.keys.toList()[position]
        val memo = memos[key]!!

        Log.v("[Factory getViewAt position]", position.toString())

        return RemoteViews(context.packageName, R.layout.memo_list_item).apply {
            setTextViewText(R.id.tvTitle, memo.title)
            setTextViewText(R.id.tvContent, memo.content)
            setInt(R.id.llMemoListItem, "setBackgroundColor", memo.backgroundColor(context))
        }
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
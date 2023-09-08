package com.womosoft.memo

import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class MemoRemoteViewsFactory(
    private val context: Context,
    private val intent: Intent
) : RemoteViewsService.RemoteViewsFactory {
    private val gson = Gson()
    private lateinit var memos: Map<String, Memo>

    override fun onCreate() {}

    override fun onDataSetChanged() {
        val memosJson = intent.getStringExtra("memosJson") ?: "{}"
        val type = object : TypeToken<Map<String, Memo>>() {}.type
        memos = gson.fromJson(memosJson, type)
        Log.v("Changed:memos", memos.toString())
    }

    override fun onDestroy() {}

    override fun getCount(): Int = memos.size

    override fun getViewAt(position: Int): RemoteViews {
        return RemoteViews(context.packageName, R.layout.memo_list_item).apply {
            val key: String = memos.keys.toList()[position]
            setTextViewText(R.id.tvTitle, memos[key]?.title)
            setTextViewText(R.id.tvContent, memos[key]?.content)
        }
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}
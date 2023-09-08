package com.womosoft.memo

import android.content.Context
import android.widget.RemoteViews
import android.widget.RemoteViewsService

class MemoRemoteViewsFactory(
    private val context: Context, private val memos: Map<String, Memo>
): RemoteViewsService.RemoteViewsFactory {
    override fun onCreate() {}

    override fun onDataSetChanged() {
    }

    override fun onDestroy() {
    }

    override fun getCount(): Int = memos.size

    override fun getViewAt(position: Int): RemoteViews {

        return RemoteViews(context.packageName, R.layout.memo_list_item);
    }

    override fun getLoadingView(): RemoteViews? = null

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = false
}
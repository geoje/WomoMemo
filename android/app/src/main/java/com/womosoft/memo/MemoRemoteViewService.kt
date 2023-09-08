package com.womosoft.memo

import android.content.Intent
import android.widget.RemoteViewsService
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class MemoRemoteViewsService: RemoteViewsService() {
    private val gson = Gson()
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        val memosJson = intent?.getStringExtra("memosJson") ?: "{}"
        val type = object: TypeToken<Map<String, Memo>>(){}.type
        val memos = gson.fromJson<Map<String, Memo>>(memosJson, type)

        return MemoRemoteViewsFactory(this.applicationContext, memos)
    }
}
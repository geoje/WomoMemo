package com.womosoft.memo

import android.content.Intent
import android.util.Log
import android.widget.RemoteViewsService
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

class MemoRemoteViewsService: RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return MemoRemoteViewsFactory(this.applicationContext, intent)
    }
}
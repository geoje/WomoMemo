package com.womosoft.memo

import android.content.Intent
import android.widget.RemoteViewsService

class MemoRemoteViewsService: RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return MemoRemoteViewsFactory(this.applicationContext)
    }
}
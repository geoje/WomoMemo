package com.womosoft.memo

import android.content.Intent
import android.widget.RemoteViewsService

class MemoRemoteViewService: RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsFactory {
        return ContactRemoteViewsFactory(this.applicationContext)
    }
}
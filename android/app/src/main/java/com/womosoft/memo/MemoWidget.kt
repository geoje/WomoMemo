package com.womosoft.memo

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews


class MemoWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val serviceIntent = Intent(context, MemoRemoteViewsService::class.java)
            val views = RemoteViews(context.packageName, R.layout.memo_widget).apply {
                setRemoteAdapter(R.id.lvMain, serviceIntent)
            }
            Log.v("[Factory appWidgetId]", appWidgetId.toString())

            appWidgetManager.updateAppWidget(appWidgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.lvMain)
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }
}
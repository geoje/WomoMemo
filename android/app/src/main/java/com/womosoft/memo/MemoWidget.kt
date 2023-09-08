package com.womosoft.memo

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.HomeWidgetPlugin


class MemoWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val memosJson = widgetData.getString("memosJson", "{}") ?: "{}"

            val serviceIntent = Intent(context, MemoRemoteViewsService::class.java).apply {
                putExtra("memosJson", memosJson)
            }
            val views = RemoteViews(context.packageName, R.layout.memo_widget).apply {
                setRemoteAdapter(R.id.lvMain, serviceIntent)
            }

            Log.v("onUpdate:memosJson", memosJson)

            appWidgetManager.updateAppWidget(appWidgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.lvMain)
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }
}
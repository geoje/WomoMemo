package com.womosoft.memo

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
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
            // Get reference to SharedPreferences
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.memo_widget).apply {

                val memosJson = widgetData.getString("memosJson", "{}") ?: "{}"
                val serviceIntent = Intent(context, MemoRemoteViewsService::class.java)
                serviceIntent.putExtra("memosJson", memosJson)
                setRemoteAdapter(R.id.lvMain, serviceIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
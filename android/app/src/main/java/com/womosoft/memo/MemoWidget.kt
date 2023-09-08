package com.womosoft.memo

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
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

                val memos = widgetData.getString("memosJson", "{}")
                setTextViewText(R.id.memo_widget_content1, memos ?: "No memos")
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
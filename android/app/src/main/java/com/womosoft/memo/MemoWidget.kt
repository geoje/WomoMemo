package com.womosoft.memo

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent


class MemoWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val serviceIntent = Intent(context, MemoRemoteViewsService::class.java)
            val pendingIntentWithData = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java
            )
            val views = RemoteViews(context.packageName, R.layout.memo_widget).apply {
                setRemoteAdapter(R.id.lstMain, serviceIntent)
                setPendingIntentTemplate(R.id.lstMain, pendingIntentWithData)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.lstMain)
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }
}
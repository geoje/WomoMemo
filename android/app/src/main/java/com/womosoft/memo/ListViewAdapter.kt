package com.womosoft.memo

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView

class ListViewAdapter(private val memos: Map<String, Memo>):BaseAdapter() {
    override fun getCount(): Int = memos.size

    override fun getItem(position: Int): Map.Entry<String, Memo> = memos.entries.toList()[position]

    override fun getItemId(position: Int): Long = position.toLong()

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        var view = convertView
        if (view == null) view = LayoutInflater.from(parent?.context).inflate(R.layout.memo_list_item, parent, false)

        val item = getItem(position)
        view!!.findViewById<TextView>(R.id.tvTitle).text = item.value.title
        view.findViewById<TextView>(R.id.tvContent).text = item.value.content

        return view
    }
}
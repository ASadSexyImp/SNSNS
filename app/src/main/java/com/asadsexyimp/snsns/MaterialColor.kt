package com.asadsexyimp.snsns

import android.R.color
import android.content.Context
import java.lang.reflect.Field
import java.util.*
import java.util.regex.Matcher
import java.util.regex.Pattern
import javax.swing.UIManager.put
import kotlin.collections.ArrayList
import kotlin.collections.HashMap



class MaterialColor {
    private val sRandom: Random = Random()
    private var sMaterialHashMap: HashMap<String, Int>? = null
    private val sColorPattern: Pattern = Pattern.compile("_[aA]?+\\d+")

    private fun getMaterialColors(context: Context): HashMap<String, Int>? {
        val fields: Array<Field> = color::class.java.fields
        val materialHashMap = HashMap<String, Int>(fields.size)
        for (field in fields) {
            if (field.getType() !== Int::class.javaPrimitiveType) continue
            val fieldName: String = field.getName() //prone to errors but okay for a sample!
            if (fieldName.startsWith("abc") || fieldName.startsWith("material")) continue
            try {
                val resId: Int = field.getInt(null)
                materialHashMap[fieldName] = context.getResources().getColor(resId)
            } catch (e: IllegalAccessException) {
                e.printStackTrace()
            }
        }
        return materialHashMap
    }

    fun random(
        context: Context,
        regex: String?
    ): Map.Entry<String, Int>? {
        if (sMaterialHashMap == null) {
            sMaterialHashMap = getMaterialColors(context)
        }
        val pattern: Pattern = Pattern.compile(regex)
        val materialColors: MutableList<Map.Entry<String, Int>> =
            ArrayList()
        for (entry in sMaterialHashMap.entrySet()) {
            if (!pattern.matcher(entry.key).matches()) continue
            materialColors.add(entry)
        }
        val rndIndex: Int = sRandom.nextInt(materialColors.size)
        return materialColors[rndIndex]
    }

    fun getContrastColor(colourName: String): Int {
        return sMaterialHashMap!![colourName + "_700"]
    }

    fun getColorName(entry: Map.Entry<String, Int?>): String? {
        val color = entry.key
        val matcher: Matcher = sColorPattern.matcher(color)
        return if (matcher.find()) {
            color.substring(0, matcher.start())
        } else null
    }
}
package com.asadsexyimp.snsns

import android.graphics.*
import android.graphics.drawable.Drawable


class TextDrawable(val text: String) : Drawable() {
    private val paint: Paint
    override fun draw(canvas: Canvas) {
        val bounds: Rect = bounds
        canvas.drawText(
            text,
            bounds.centerX() - 15f /*just a lazy attempt to centre the text*/ * text.length,
            bounds.centerY() + 15f,
            paint
        )
    }

    override fun setAlpha(alpha: Int) {
        paint.setAlpha(alpha)
    }

    override fun setColorFilter(cf: ColorFilter?) {
        paint.setColorFilter(cf)
    }

    override fun getOpacity(): Int {
        return PixelFormat.TRANSLUCENT
    }

    init {
        paint = Paint()
        paint.setColor(Color.WHITE)
        paint.setTextSize(52f)
        paint.setAntiAlias(true)
        paint.setFakeBoldText(true)
        paint.setShadowLayer(12f, 0f, 0f, Color.BLACK)
        paint.setStyle(Paint.Style.FILL)
        paint.setTextAlign(Paint.Align.LEFT)
    }
}
package com.asadsexyimp.snsns

import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_bullet.*
import kotlinx.android.synthetic.main.activity_main.*

class bullet : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bullet)

        // move page
        val home_intent: Intent = Intent(this, MainActivity::class.java)

        // SNS register
        button3.setOnClickListener {
            startActivity(home_intent)
        }
    }
}


package com.asadsexyimp.snsns

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_bang.*
import kotlinx.android.synthetic.main.activity_bullet.*

class Bang : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bang)

        // move page
        val home_intent: Intent = Intent(this, MainActivity::class.java)

        // SNS register
        button4.setOnClickListener {
            startActivity(home_intent)
        }
    }
}

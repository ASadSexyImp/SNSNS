package com.asadsexyimp.snsns

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // move page
        val bullet_intent: Intent = Intent(this, BulletActivity::class.java)
        val bang_intent: Intent = Intent(this, Bang::class.java)

        // SNS register
        button.setOnClickListener {
            startActivity(bullet_intent)
        }

        // SNS share start
        button2.setOnClickListener {
            startActivity(bang_intent)
        }
    }
}

package com.asadsexyimp.snsns

import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_bullet.*
import kotlinx.android.synthetic.main.activity_main.*
import android.R
import android.widget.Spinner
//import androidx.core.app.ComponentActivity
//import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
//import sun.jvm.hotspot.utilities.IntArray
import androidx.core.app.ComponentActivity
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
//import sun.jvm.hotspot.utilities.IntArray





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

//        // selcted spiner info
//        val spinner = this.findViewById(R.id.spinner) as Spinner
//        val str = spinner.selectedItem as String
//        println(str)
    }
}


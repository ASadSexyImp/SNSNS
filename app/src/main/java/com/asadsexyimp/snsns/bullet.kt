package com.asadsexyimp.snsns

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import kotlinx.android.synthetic.main.activity_bullet.*
import android.widget.Spinner
//import androidx.core.app.ComponentActivity
//import androidx.core.app.ComponentActivity.ExtraData
//import sun.jvm.hotspot.utilities.IntArray
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter

//import sun.jvm.hotspot.utilities.IntArray





class bullet : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bullet)

        // choice
        val spinnerItems = arrayOf("Facebook", "Instagram", "Whatsapp", "Twitter", "LINE",  "Telegram", "Kakaotalk", "Pintarest", "WeChat", "Tik Tok", "LinkedIn")

        // move page
        val home_intent: Intent = Intent(this, MainActivity::class.java)

        // SNS register
        button3.setOnClickListener {
            startActivity(home_intent)
        }

        // ArrayAdapter
        val adapter = ArrayAdapter(applicationContext,
            android.R.layout.simple_spinner_item, spinnerItems)

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        // set spinner to adapter
        spinner.adapter = adapter

        // listener
        spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener{
            override fun onItemSelected(parent: AdapterView<*>?,
                                        view: View?, position: Int, id: Long) {
                val spinnerParent = parent as Spinner
                val item = spinnerParent.selectedItem as String
                textView2.text = item
            }

            //　アイテムが選択されなかった
            override fun onNothingSelected(parent: AdapterView<*>?) {
                //
            }
        }

        imageView.setOnClickListener{
            val show: Any =
                Snackbar.make("action", Snackbar.LENGTH_LONG).setAction("Action", null).show()
        }

    }
}


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
import com.google.android.material.snackbar.Snackbar
import android.provider.MediaStore
import android.graphics.Bitmap
import android.app.Activity
import androidx.core.app.ComponentActivity
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import android.net.Uri
//import sun.jvm.hotspot.utilities.IntArray
import java.io.IOException
import java.util.*
import android.util.Log
import io.realm.Realm
import io.realm.RealmResults
import io.realm.RealmObjectSchema
import io.realm.DynamicRealm
import io.realm.RealmMigration
import io.realm.RealmConfiguration

//import sun.jvm.hotspot.utilities.IntArray



class BulletActivity : AppCompatActivity() {
    private val READ_REQUEST_CODE = 42

    // choice
    val spinnerItems = arrayOf("Facebook", "Instagram", "Whatsapp", "Twitter", "LINE",  "Telegram", "Kakaotalk", "Pintarest", "WeChat", "Tik Tok", "LinkedIn")

    // realm setting
    private val mRealm: Realm by lazy {
        Realm.getDefaultInstance()
    }

    var snsFlag: Boolean = false
    var qrFlag : Boolean = false
    var qrImage : String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bullet)

        // move page
        val home_intent: Intent = Intent(this, MainActivity::class.java)

        // aback to home
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
                snsFlag = true
            }

            //　not selected item
            override fun onNothingSelected(parent: AdapterView<*>?) {

            }
        }

        imageView.setOnClickListener{
            val intent = Intent(Intent.ACTION_OPEN_DOCUMENT)
            intent.addCategory(Intent.CATEGORY_OPENABLE)
            intent.type = "image/*"
            startActivityForResult(intent, READ_REQUEST_CODE)
        }

        // SNS register
        button4.setOnClickListener {
            println("push!")
            println(snsFlag.toString())
            println(qrFlag.toString())
            if (snsFlag && qrFlag) {
                create(textView2.text.toString(), qrImage)
                println("created!!")
            }
        }
//
//        // read test
//        val getData = read()
//        getData.forEach {
//            Log.d("debug","name :" + it.name + "price : " + it.qr.toString())
//        }
//
//        // update test
//        update(getData.first()!!.id, "updated")
//
//        val getUpdatedData = read()
//        getUpdatedData.forEach {
//            Log.d("debug","name :" + it.name + "price : " + it.qr.toString())
//        }
//
//        // delete test
//        delete(getData.first()!!.id)
//
//        val getDeletedData = read()
//        getDeletedData.forEach {
//            Log.d("debug","name :" + it.name + "price : " + it.qr.toString())
//        }

    }

    // local strage access
    public override fun onActivityResult(
        requestCode: Int, resultCode: Int,
        resultData: Intent?
    ) {

        if (requestCode == READ_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            var uri: Uri? = null
            if (resultData != null) {
                uri = resultData.data
                qrFlag = true
                qrImage = uri.toString()
                try {
                    val bitmap = MediaStore.Images.Media.getBitmap(contentResolver, uri)
                    imageView.setImageBitmap(bitmap)

                } catch (e: IOException) {
                    e.printStackTrace()
                }

            }
        }
    }



    override fun onDestroy() {
        super.onDestroy()
        mRealm.close()
    }

    // realm CRUD
    fun create(name:String, qr:String){
        mRealm.executeTransaction {
            var bullet = mRealm.createObject(Bullet::class.java , UUID.randomUUID().toString())
            bullet.name = name
            bullet.qr = qr
            mRealm.copyToRealm(bullet)
        }
    }

    fun read() : RealmResults<Bullet> {
        return mRealm.where(Bullet::class.java).findAll()
    }

    fun update(id:String, name:String, qr:String){
        mRealm.executeTransaction {
            var bullet = mRealm.where(Bullet::class.java).equalTo("id",id).findFirst()
            bullet!!.name = name
//            if(price != 0.toLong()) {
//                book.qr = price
//            }
        }
    }

    fun delete(id:String){
        mRealm.executeTransaction {
            var bullet = mRealm.where(Bullet::class.java).equalTo("id",id).findAll()
            bullet.deleteFromRealm(0)
        }
    }
}


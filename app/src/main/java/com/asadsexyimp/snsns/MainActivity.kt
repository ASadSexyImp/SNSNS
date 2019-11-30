package com.asadsexyimp.snsns

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*
import java.util.*
//import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import androidx.core.net.toUri
import io.realm.Realm
import io.realm.RealmResults
import io.realm.RealmObjectSchema
import io.realm.DynamicRealm
import io.realm.RealmMigration
import io.realm.RealmConfiguration
import kotlinx.android.synthetic.main.activity_bullet.*

class MainActivity : AppCompatActivity() {

    // realm setting
    private val mRealm: Realm by lazy {
        Realm.getDefaultInstance()
    }


    var uri: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // move page
        val bullet_intent: Intent = Intent(this, BulletActivity::class.java)

        // SNS register
        button.setOnClickListener {
            startActivity(bullet_intent)
        }

        // SNS QR show
        button2.setOnClickListener {
            val bitmap = MediaStore.Images.Media.getBitmap(contentResolver, uri?.toUri())
            imageView2.setImageBitmap(bitmap)
        }

        // read test
        val getData = read()
        getData.forEach {
//            Log.d("debug","name :" + it.name + "qr : " + it.qr.toString())
            println("name :" + it.name + "qr : " + it.qr)
            textView.text = it.name
            uri = it.qr
        }

        // update test
//        update(getData.first()!!.id, "updated")

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
        }
    }

    fun delete(id:String){
        mRealm.executeTransaction {
            var bullet = mRealm.where(Bullet::class.java).equalTo("id",id).findAll()
            bullet.deleteFromRealm(0)
        }
    }

}

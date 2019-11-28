package com.asadsexyimp.snsns

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*
import java.util.*
//import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import io.realm.Realm
import io.realm.RealmResults
import io.realm.RealmObjectSchema
import io.realm.DynamicRealm
import io.realm.RealmMigration
import io.realm.RealmConfiguration

class MainActivity : AppCompatActivity() {

    private lateinit var mRealm : Realm

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // realm setting
        Realm.init(this)
        val realmConfig = RealmConfiguration.Builder()
            .deleteRealmIfMigrationNeeded()
            .build()
        mRealm = Realm.getInstance(realmConfig)

        // move page
        val bullet_intent: Intent = Intent(this, BulletActivity::class.java)

        // SNS register
        button.setOnClickListener {
            startActivity(bullet_intent)
        }

        // SNS share start
        button2.setOnClickListener {
            startActivity(bullet_intent)
        }

//
//        // create test
//        create("test1",1)
//        create("test2")
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

    // realm CRUD

    override fun onDestroy() {
        super.onDestroy()
        mRealm.close()
    }

    fun create(name:String, price:String){
        mRealm.executeTransaction {
            var book = mRealm.createObject(Bullet::class.java , UUID.randomUUID().toString())
            book.name = name
            book.qr = price
            mRealm.copyToRealm(book)
        }
    }

    fun read() : RealmResults<Bullet> {
        return mRealm.where(Bullet::class.java).findAll()
    }

    fun update(id:String, name:String, qr:String){
        mRealm.executeTransaction {
            var book = mRealm.where(Bullet::class.java).equalTo("id",id).findFirst()
            book!!.name = name
//            if(price != 0.toLong()) {
//                book.qr = price
//            }
        }
    }

    fun delete(id:String){
        mRealm.executeTransaction {
            var book = mRealm.where(Bullet::class.java).equalTo("id",id).findAll()
            book.deleteFromRealm(0)
        }
    }

}

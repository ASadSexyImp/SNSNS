package com.asadsexyimp.snsns

//import android.support.v7.app.AppCompatActivity


import com.asadsexyimp.snsns.R
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.res.ResourcesCompat
import androidx.core.net.toUri
import com.lukedeighton.wheelview.WheelView
import com.lukedeighton.wheelview.WheelView.*
import com.lukedeighton.wheelview.adapter.WheelAdapter
import io.realm.Realm
import io.realm.RealmResults
import kotlinx.android.synthetic.main.activity_main.*
//import sun.jvm.hotspot.utilities.IntArray


//import sun.jvm.hotspot.utilities.IntArray


//import sun.jvm.hotspot.utilities.IntArray
//import sun.util.locale.provider.LocaleProviderAdapter.getAdapter


class MainActivity : AppCompatActivity() {

    // realm setting
    private val mRealm: Realm by lazy {
        Realm.getDefaultInstance()
    }

    private val ITEM_COUNT = 4
    var uri: String? = null
    var snslist = mutableListOf<Bullet>()

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
            var bitmap = MediaStore.Images.Media.getBitmap(contentResolver, uri?.toUri())
            // resize image
            bitmap = Bitmap.createScaledBitmap(bitmap, 480, 410, true);
            imageView2.setImageBitmap(bitmap)
            snslist.forEach {
                it.name
            }
        }

        // read test
        val getData = read()
        getData.forEach {
            snslist.add(Bullet(it.id, it.name, it.qr))
        }

        val numbers =
            arrayOf(
                R.drawable.fb,
                R.drawable.insta,
                R.drawable.twitter,
                R.drawable.line
            )

        wheelView.adapter = object : WheelAdapter {
            override fun getDrawable(position: Int): Drawable? {
                //return drawable here - the position can be seen in the gifs above
                return ResourcesCompat.getDrawable(
                    resources,
                    numbers[position],
                    null
                )

            }

            override fun getCount(): Int {
                //return the count
                return numbers.size
            }
        }

        wheelView.setOnWheelItemSelectedListener { parent, itemDrawable, position ->
            //the adapter position that is closest to the selection angle and it's drawable
            Log.d("parent(Selected)", parent.toString())
            Log.d("itemDrawable(Selected)", itemDrawable.toString())
            Log.d("position(Selected)", position.toString())
        }

        wheelView.onWheelItemClickListener =
            WheelView.OnWheelItemClickListener { parent, position, isSelected ->
                //the position in the adapter and whether it is closest to the selection angle
                Log.d("parent(Click)", parent.toString())
                Log.d("position(Click)", position.toString())
                Log.d("isSelected(Click)", isSelected.toString())
            }

        wheelView.onWheelAngleChangeListener = WheelView.OnWheelAngleChangeListener {
            //the new angle of the wheel
            Log.d("angle", it.toString())
        }

    }


    // realm setting
    override fun onDestroy() {
        super.onDestroy()
        mRealm.close()
    }

    // realm CRUD

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

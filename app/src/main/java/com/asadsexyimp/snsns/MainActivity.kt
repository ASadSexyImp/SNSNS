package com.asadsexyimp.snsns

//import android.support.v7.app.AppCompatActivity


import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import android.widget.LinearLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.core.net.toUri
import androidx.core.view.isVisible
import com.lukedeighton.wheelview.WheelView
import com.lukedeighton.wheelview.adapter.WheelAdapter
import io.realm.Realm
import io.realm.RealmResults
import kotlinx.android.synthetic.main.activity_main.*
import sun.jvm.hotspot.utilities.IntArray


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
    var selectedNum: Int = 0
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

        // image
        imageView2.setOnClickListener {
            imageView2.isVisible = false
        }

        // read test
        var numbers = mutableListOf<String>()
        val getData = read()
        getData.forEach {
            snslist.add(Bullet(it.id, it.name, it.qr))
            numbers.add(it.qr)
        }
        val layout = findViewById(R.id.size)


        wheelView.adapter = object : WheelAdapter {
            override fun getDrawable(position: Int): Drawable? {
//                return drawable here - the position can be seen in the gifs above
                var bitmap = MediaStore.Images.Media.getBitmap(contentResolver, numbers[position].toUri())
                // resize image
                bitmap = Bitmap.createScaledBitmap(bitmap, 100, 100, true);

                return BitmapDrawable(getResources(), bitmap)

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
                if(isSelected){
                    imageView2.isVisible = true
                    uri = snslist[position].qr
                    println(uri)
                    var bitmap = MediaStore.Images.Media.getBitmap(contentResolver, uri?.toUri())
                    // resize image
                    bitmap = Bitmap.createScaledBitmap(bitmap, 700, 700, true);
                    imageView2.setImageBitmap(bitmap)
                }
            }

        wheelView.onWheelAngleChangeListener = WheelView.OnWheelAngleChangeListener {
            //the new angle of the wheel
//            Log.d("angle", it.toString())
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

    fun delete(id:String){
        mRealm.executeTransaction {
            var bullet = mRealm.where(Bullet::class.java).equalTo("id",id).findAll()
            bullet.deleteFromRealm(0)
        }
    }

}

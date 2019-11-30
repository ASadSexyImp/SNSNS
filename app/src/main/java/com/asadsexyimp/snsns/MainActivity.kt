package com.asadsexyimp.snsns

//import android.support.v7.app.AppCompatActivity

import android.R
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.graphics.drawable.LayerDrawable
import android.graphics.drawable.ShapeDrawable
import android.graphics.drawable.shapes.OvalShape
import android.os.Bundle
import android.provider.MediaStore
import android.view.Menu
import android.view.MenuItem
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.net.toUri
import com.lukedeighton.wheelview.WheelView
import com.lukedeighton.wheelview.adapter.WheelArrayAdapter
import io.realm.Realm
import io.realm.RealmResults
import kotlinx.android.synthetic.main.activity_main.*
//import sun.jvm.hotspot.utilities.IntArray
//import sun.util.locale.provider.LocaleProviderAdapter.getAdapter


class MainActivity : AppCompatActivity() {

    // realm setting
    private val mRealm: Realm by lazy {
        Realm.getDefaultInstance()
    }

    private val ITEM_COUNT = 10
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




        val wheelView: WheelView = findViewById(R.id.wheelview) as WheelView

        //create data for the adapter
        //create data for the adapter
        val entries: MutableList<Map.Entry<String, Int>> =
            ArrayList(ITEM_COUNT)
        for (i in 0 until ITEM_COUNT) {
            val entry: Map.Entry<String, Int> =
                MaterialColor.random(this, "\\D*_500$")
            entries.add(entry)
        }

        //populate the adapter, that knows how to draw each item (as you would do with a ListAdapter)
        //populate the adapter, that knows how to draw each item (as you would do with a ListAdapter)
        wheelView.setAdapter(MaterialColorAdapter(entries))

        //a listener for receiving a callback for when the item closest to the selection angle changes
        //a listener for receiving a callback for when the item closest to the selection angle changes
        wheelView.setOnWheelItemSelectedListener(object : WheelView.OnWheelItemSelectListener() {
            fun onWheelItemSelected(
                parent: WheelView,
                itemDrawable: Drawable?,
                position: Int
            ) { //get the item at this position
                val selectedEntry: Map.Entry<String, Int> =
                    (parent.getAdapter() as MaterialColorAdapter).getItem(position)
                parent.setSelectionColor(getContrastColor(selectedEntry))
            }
        })

        wheelView.setOnWheelItemClickListener(object : WheelView.OnWheelItemClickListener() {
            fun onWheelItemClick(
                parent: WheelView?,
                position: Int,
                isSelected: Boolean
            ) {
                val msg = "$position $isSelected"
                Toast.makeText(this@MainActivity, msg, Toast.LENGTH_SHORT).show()
            }
        })

        //initialise the selection drawable with the first contrast color
        //initialise the selection drawable with the first contrast color
        wheelView.setSelectionColor(getContrastColor(entries[0]))

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


    //get the materials darker contrast
    private fun getContrastColor(entry: Map.Entry<String, Int>): Int {
        val colorName: String = MaterialColor.getColorName(entry)
        return MaterialColor.getContrastColor(colorName)
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        val id: Int = item.getItemId()
        return if (id == R.id.action_settings) {
            true
        } else super.onOptionsItemSelected(item)
    }

    internal class MaterialColorAdapter(entries: List<Map.Entry<String?, Int?>?>?) :
        WheelArrayAdapter<Map.Entry<String?, Int?>?>(entries) {
        fun getDrawable(position: Int): Drawable {
            val drawable =
                arrayOf(
                    createOvalDrawable(getItem(position).getValue()),
                    TextDrawable(position.toString())
                )
            return LayerDrawable(drawable)
        }

        private fun createOvalDrawable(color: Int): Drawable {
            val shapeDrawable = ShapeDrawable(OvalShape())
            shapeDrawable.paint.color = color
            return shapeDrawable
        }
    }

}

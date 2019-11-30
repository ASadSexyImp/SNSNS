package com.asadsexyimp.snsns
import android.app.Application
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.RealmResults
import java.util.*

class `MyApplication` : Application() {
    override fun onCreate() {
        super.onCreate()
        Realm.init(this)
        val realmConfig = RealmConfiguration.Builder()
            .deleteRealmIfMigrationNeeded()
            .build()
        Realm.setDefaultConfiguration(realmConfig)
    }
}
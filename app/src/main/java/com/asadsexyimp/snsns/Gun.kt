package com.asadsexyimp.snsns;

import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.Required
import java.util.*


open class Bullet(
        @PrimaryKey open var id : String = UUID.randomUUID().toString(),
        @Required open var name : String = "",
        @Required open var qr : String = ""
) : RealmObject() {}

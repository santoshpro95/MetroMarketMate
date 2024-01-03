package com.google.metromarketmate.activities

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.ImageView
import com.bumptech.glide.Glide
import com.google.firebase.FirebaseApp
import com.google.metromarketmate.R

class MainActivity : AppCompatActivity() {

    // region Common Variables
    lateinit var  storageImage: ImageView
    // endregion

    // region On Create
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        init()
    }
    // endregion

    // region init
    private fun init(){
        FirebaseApp.initializeApp(this)

        // loadData
        loadData()

        // init Components
        initComponents()

        // setup firebase storage
        setupStorage()
    }
    // endregion

    // region initComponents
    private fun initComponents(){
        storageImage = findViewById(R.id.storageImage)
    }
    // endregion

    // region loadData
    private fun loadData(){
        // Set up an OnPreDrawListener to the root view.
        val content: View = findViewById(android.R.id.content)
        content.viewTreeObserver.addOnPreDrawListener { // Check whether the initial data is ready.
            true
        }
    }
    // endregion

    // region setupStorage
    private fun setupStorage(){
        val imagePath = "https://firebasestorage.googleapis.com/v0/b/metromarketmate.appspot.com/o/demo.jpg?alt=media&token=74d7e451-913a-41b6-8fd1-6ee260548bd8"

        // Load and display the image using Glide
        Glide.with(this)
            .load(imagePath)
            .into(storageImage)
    }
    // endregion

}
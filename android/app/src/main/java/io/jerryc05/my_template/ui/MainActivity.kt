package io.jerryc05.my_template.ui

//import androidx.appcompat.app.AppCompatActivity
import android.app.Activity
import android.os.Bundle
import android.view.View
import io.jerryc05.my_template.databinding.ActivityMainBinding


//class MainActivity : AppCompatActivity() {
class MainActivity : Activity(), View.OnClickListener {

  private lateinit var binding: ActivityMainBinding

  @ExperimentalUnsignedTypes
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    binding = ActivityMainBinding.inflate(layoutInflater)
    setContentView(binding.root)
  }

  override fun onClick(p0: View?) {
    TODO("Not yet implemented")
  }
}
package com.example.yy.fabflix;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

public class ItemActivity extends AppCompatActivity {

    private TextView item_text;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_item);

        Bundle bundle = getIntent().getExtras();


        String contents = bundle.getString("message");
        item_text   = (TextView)findViewById(R.id.item);
        item_text.setText(contents);
        Log.d("message",contents);
    }
}

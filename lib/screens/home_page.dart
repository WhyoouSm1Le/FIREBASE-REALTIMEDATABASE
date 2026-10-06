import 'package:firebase_rtdb/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widget/custom_read_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Agro Tech", 
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.bold
              )
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff36725D),
          ),
          body: Center(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // TEMPERATUR
                CustomReadField(
                  result: "${appProvider.sensorData.temp}", 
                  borderColor: const Color(0xff36725D), 
                  image: 'thermometer.png'
                ),

                const SizedBox(height: 20),

                // HUMIDITY
                CustomReadField(
                  result: "${appProvider.sensorData.humidity}",
                  borderColor: const Color(0xff36725D),
                  image: 'humidity_sensor.png',
                ),

                const SizedBox(height: 20),

                // SOIL MOISTURE
                CustomReadField(
                  result: "${appProvider.sensorData.soil}",
                  borderColor: const Color(0xff36725D),
                  image: 'soil_analysis.png',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



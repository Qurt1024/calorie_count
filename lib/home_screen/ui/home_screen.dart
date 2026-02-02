import 'package:calorie_count/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(padding:const EdgeInsets.symmetric(horizontal: 27.0),
      child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
          color: AppColors.container,
          borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'placeholder'
          ),
        )
      ],
      ),
      ),
    );
  }
}
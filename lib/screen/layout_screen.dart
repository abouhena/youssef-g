

import 'package:tourism_app/bloc/app_cubit.dart';
import 'package:tourism_app/bloc/app_state.dart';
import 'package:tourism_app/screen/add_screen.dart';
import 'package:tourism_app/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutScreen extends StatelessWidget {
  LayoutScreen({Key? key}) : super(key: key);

  List<Widget> listScreen=[
     const HomeScreen(),
    const AddScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      builder: (context,state){
        var cubit=AppCubit.get(context);
        return Scaffold(
          body: listScreen[cubit.currentIndexNav],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: cubit.currentIndexNav,
            onTap: (val){
              cubit.changeCurrentIndexNav(val);
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: const Color(0xffFFBB2B),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
              ),

              BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label:'Add'
              ),


            ],
          ),
        );
      },
      listener:(context,state){

      },
    );
  }
}


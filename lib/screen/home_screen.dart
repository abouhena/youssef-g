
import 'package:tourism_app/bloc/app_cubit.dart';
import 'package:tourism_app/bloc/app_state.dart';
import 'package:tourism_app/screen/chat_bot_screen.dart';
import 'package:tourism_app/screen/detais_screen.dart';
import 'package:tourism_app/screen/image_ai_screen.dart';
import 'package:tourism_app/screen/login_screen.dart';
import 'package:tourism_app/screen/profile_screen.dart';
import 'package:tourism_app/services/shared_pref_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int num = 0;

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).getAllTourismPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<String> nameScreen = [
      'All',
      'Pharonic',
      'Chrstians',
      'Islamic',
    ];

    return BlocBuilder<AppCubit,AppState>(
        builder: (context,state){
          var cubit = AppCubit.get(context);
      return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: const Color(0xffFFBB2B),
              title: Text(nameScreen[num],),

              actions: [
                InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return const ImageAiScreen();
                      }));
                    },
                    child: const Icon(Icons.cloud_upload)),
                const SizedBox(width: 15,),

                InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return const ChatBotScreen();
                      }));
                    },
                    child: const Icon(Icons.chat)),
                const SizedBox(width: 15,),

                InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return const ProfileScreen();
                      }));
                    },
                    child: const Icon(Icons.perm_contact_cal_outlined)),
                const SizedBox(width: 15,),

                InkWell(
                    onTap: (){
                      SharedPref.removeDate(key: 'kToken',);
                      SharedPref.removeDate(key: 'kUserId',);
                      SharedPref.removeDate(key: 'kLogin',);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                        return LoginScreen();
                      }), (route) => false);

                    },
                    child: const Icon(Icons.logout)),
                const SizedBox(width: 15,),
              ],

              bottom: TabBar(
                indicatorColor: const Color(0XFF0047AB),
                isScrollable: true,
                physics: const BouncingScrollPhysics(),
                tabs: [
                  Text(nameScreen[0]),
                  Text(nameScreen[1]),
                  Text(nameScreen[2]),
                  Text(nameScreen[3]),
                ],
                labelStyle: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins'
                ),
                onTap: (val){
                  setState(() {
                    num=val;
                  });
                  if(val==0){
                    cubit.getAllTourismPlaces();
                  }else if (val == 1){
                    cubit.getCategoryTourismPlaces(id: '1');
                  }else if (val == 2){
                    cubit.getCategoryTourismPlaces(id: '2');
                  }else{
                    cubit.getCategoryTourismPlaces(id: '3');
                  }
                },
              ),
            ),
            body: (state is LoadingGetTourismPlacesState)?
            const Center(child: CircularProgressIndicator()):
            cubit.tourismPlacesList.isEmpty?
            const Center(
              child: Text('Empty Data',
              style:TextStyle(
                color:Colors.black,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
              ) ,),
            ):TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ...List.generate(4, (index){
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: cubit.tourismPlacesList.length,
                    itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return DetailsScreen(tourismPlacesModel: cubit.tourismPlacesList[index],val: num,);
                            }));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(cubit.tourismPlacesList[index].image??'',
                                  fit: BoxFit.fill,
                                  height: 200,width: double.infinity,),
                                )
,
                                const SizedBox(height: 10,),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(cubit.tourismPlacesList[index].placeName??'',
                                      maxLines: 1,overflow: TextOverflow.ellipsis,softWrap: true,
                                      style: const TextStyle(
                                        color:Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),),
                                    ),
                                    const SizedBox(width: 5,),
                                    InkWell(
                                       onTap: ()async{
                                         try{
                                           await launch(cubit.tourismPlacesList[index].location??'');
                                         }catch(e){
                                           debugPrint(e.toString());
                                         }

                                       },
                                        child: const Icon(Icons.location_on_outlined,color: Color(0xffFFBB2B),))
                                  ],
                                )
                              ],

                            ),
                          ),
                        );
                    },
                  );
                })

              ],
            )
        ),
      );
    });
  }
}



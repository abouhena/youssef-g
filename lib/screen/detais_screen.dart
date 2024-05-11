

import 'package:tourism_app/bloc/app_cubit.dart';
import 'package:tourism_app/bloc/app_state.dart';
import 'package:tourism_app/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  final TourismPlacesModel tourismPlacesModel;
  final int val;
  const DetailsScreen({Key? key, required this.tourismPlacesModel, required this.val}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffFFBB2B),
        title: const Text('Detils',),
      ),
      body: SingleChildScrollView(

        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           Image.network(widget.tourismPlacesModel.image??'',
             fit: BoxFit.fill,
             height: 200,width: double.infinity,)
           ,
           const SizedBox(height: 10,),

           BlocConsumer<AppCubit,AppState>(
               builder: (context,state){
                 var cubit = AppCubit.get(context);
             return Padding(
               padding: const EdgeInsets.all(10.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(widget.tourismPlacesModel.placeName??'',
                     style: const TextStyle(
                       color:Colors.black,
                       fontSize: 20,
                       fontFamily: 'Poppins',
                       fontWeight: FontWeight.w800,
                     ),),
                   const SizedBox(height: 20,),
                   Text(widget.tourismPlacesModel.description??'',
                     style: const TextStyle(
                       color:Colors.black,
                       fontSize: 18,
                       fontFamily: 'Poppins',
                       fontWeight: FontWeight.w400,
                     ),),
                   const SizedBox(height: 20,),
                   Row(
                     children: [
                       const Expanded(
                         child: Text('Call Phone Number : ',
                           style: TextStyle(
                             color:Colors.black,
                             fontSize: 20,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w800,
                           ),),
                       ),
                       const SizedBox(width: 5,),
                       InkWell(
                           onTap:()async{
                             var number = widget.tourismPlacesModel.phoneNumber??""; //set the number here
                             bool? res = await FlutterPhoneDirectCaller.callNumber(number);
                           } ,child: const Icon(Icons.call,color: Color(0xffFFBB2B),size: 30,))
                     ],
                   ),
                   const SizedBox(height: 20,),
                   Row(
                     children: [
                       const Expanded(
                         child: Text('State : ',
                           style: TextStyle(
                             color:Colors.black,
                             fontSize: 18,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w800,
                           ),),
                       ),
                       const SizedBox(width: 5,),
                       Expanded(
                         child: Text(widget.tourismPlacesModel.stateName??"",
                           style: const TextStyle(
                             color:Colors.black,
                             fontSize: 18,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w500,
                           ),),
                       ),
                     ],
                   ),
                   const SizedBox(height: 20,),
                   Row(
                     children: [
                       const Expanded(
                         child: Text('Category : ',
                           style: TextStyle(
                             color:Colors.black,
                             fontSize: 18,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w800,
                           ),),
                       ),
                       const SizedBox(width: 5,),
                       Expanded(
                         child: Text(widget.tourismPlacesModel.placeTypeName??"",
                           style: const TextStyle(
                             color:Colors.black,
                             fontSize: 18,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w500,
                           ),),
                       ),
                     ],
                   ),
                   const SizedBox(height: 20,),
                   Row(
                     children: [
                       const Expanded(
                         child: Text('Region : ',
                           style: TextStyle(
                             color:Colors.black,
                             fontSize: 18,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w800,
                           ),),
                       ),
                       const SizedBox(width: 5,),
                       Expanded(
                         child: Text(widget.tourismPlacesModel.regionName??"",
                           style: const TextStyle(
                             color:Colors.black,
                             fontSize: 18,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w500,
                           ),),
                       ),
                     ],
                   ),
                   const SizedBox(height: 20,),



                  ElevatedButton(
                     style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all(const Color(0xffFFBB2B)),
                       minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40))
                     ),
                     onPressed: () async{
                       try{
                         await launch(widget.tourismPlacesModel.location??'');
                       }catch(e){
                         debugPrint(e.toString());
                       }

                     },
                     child: const Text(
                       'Go to Place',
                       style:
                       TextStyle(
                         color: Colors.white,
                         fontSize: 18,
                         fontFamily: 'Poppins',
                         fontWeight: FontWeight.w400,
                       ),
                     ),
                   )




                 ],
               ),
             );
           },
             listener: (context,state){},
           )

         ],
        ),
      ),
    );
  }
}

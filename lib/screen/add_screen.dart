
import 'dart:convert';
import 'dart:io';

import 'package:tourism_app/bloc/app_cubit.dart';
import 'package:tourism_app/bloc/app_state.dart';
import 'package:tourism_app/widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).getPlaceType();
    BlocProvider.of<AppCubit>(context).getRegions();
    BlocProvider.of<AppCubit>(context).getState();
    BlocProvider.of<AppCubit>(context).clearFileImage();
    super.initState();
  }

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emergencyName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();

  GlobalKey<FormState> kForm = GlobalKey();

  String ? categoryId;
  String ? stateId;
  String ? regionId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tourism Places'),
        elevation: 0.0,
        backgroundColor: const Color(0xffFFBB2B),
      ),
      body: BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: kForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Center(
                    child: InkWell(
                      onTap: ()async{
                        XFile ? file = await ImagePicker().pickImage(source: ImageSource.gallery,maxWidth: 1080,maxHeight: 1080);
                        if(file !=null){
                          cubit.changeFileImage(File(file.path));
                        }
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle
                        ),
                        child: cubit.fileImage == null ?
                        const Center(child:Icon(Icons.add)):ClipOval(child: Image.file(cubit.fileImage!,fit: BoxFit.fill)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  CustomTextFormField(
                      controller: emergencyName,
                      hintText: "Place Name",
                      textInputType:
                      TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return  "Please enter Place Name";
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.all(15)),

                  const SizedBox(height: 20),

                  CustomTextFormField(
                      controller: description,
                      hintText: "Description",
                      textInputType: TextInputType.text,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return  "Please enter Description";
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.all(15)),

                  const SizedBox(height: 20),

                  CustomTextFormField(
                      controller: location,
                      hintText: "Location",
                      textInputType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return  "Please enter Location";
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.all(15)),

                  const SizedBox(height: 20),

                  CustomTextFormField(
                      controller: phoneNumber,
                      hintText: "Phone Number",
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return  "Please enter Phone Number";
                        }
                        return null;
                      },
                      contentPadding: const EdgeInsets.all(15)),

                  const SizedBox(height: 20),

                  (state is LoadingPlaceTypeState)?
                  const CircularProgressIndicator():
                  DropdownButtonFormField(
                    items:[
                      ...cubit.placeType.map((e){
                        return DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(e.name??''));
                      })
                    ],
                    onChanged: (val){
                      setState(() {
                        categoryId =val;
                      });
                    },
                    hint: const Text('PlaceType'),
                    value: categoryId,
                    decoration: InputDecoration(
                      contentPadding:const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                    ),
                    validator: (value){
                      if(value==null){
                        return 'Enter the Place Type';
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  (state is LoadingStateState)?
                  const CircularProgressIndicator():
                  DropdownButtonFormField(
                    items:[
                      ...cubit.stateList.map((e){
                        return DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(e.name??''));
                      })
                    ],
                    onChanged: (val){
                      setState(() {
                        stateId =val;
                      });
                    },
                    value: stateId,
                    hint: const Text('Status'),
                    decoration: InputDecoration(
                      contentPadding:const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                    ),
                    validator: (value){
                      if(value==null){
                        return 'Enter the Status';
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  (state is LoadingRegionState)?
                  const CircularProgressIndicator():
                  DropdownButtonFormField(
                    items:[
                      ...cubit.regionsList.map((e){
                        return DropdownMenuItem(
                            value: e.id.toString(),
                            child: Text(e.regionName??''));
                      })
                    ],
                    onChanged: (val){
                      setState(() {
                        regionId =val;
                      });
                    },
                    hint: const Text('Region'),
                    value: regionId,
                    decoration: InputDecoration(
                      contentPadding:const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:const BorderSide(color:Color(0X3D40BFFF)),
                      ),
                    ),
                    validator: (value){
                      if(value==null){
                        return 'Enter the Region';
                      }
                    },
                  ),

                  const SizedBox(height: 20),


                  (state is LoadingUploadTourismPlacesState)?
                  const Center(child: CircularProgressIndicator()):Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xffFFBB2B))
                      ),
                      onPressed: () {
                        if(kForm.currentState!.validate()){
                          if(cubit.fileImage!=null){
                            cubit.uploadTourismPlaces(
                              phoneNumber: phoneNumber.text,
                              placeTypeId: categoryId!,
                              description: description.text,
                              placeName: emergencyName.text,
                              location: location.text,
                              regionId: regionId!,
                              stateId: stateId!,
                            );
                          }else{
                            Fluttertoast.showToast(
                              msg: 'Please Enter image',
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: Colors.red,
                              gravity: ToastGravity.TOP,
                              fontSize: 18,
                              textColor: Colors.white,
                            );
                          }

                        }
                      },
                      child: const Text(
                        'Upload',
                        style:
                        TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )





                ],
              ),
            ),
          );
        },
        listener: (context,state)async{
          if(state is SuccessUploadTourismPlacesState){
            BlocProvider.of<AppCubit>(context).changeCurrentIndexNav(0);
          }else if (state is ErrorUploadTourismPlacesState){
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Error Upload')));
          }

        },
      )
    );
  }
}

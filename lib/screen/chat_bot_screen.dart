
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/bloc/app_cubit.dart';

import '../bloc/app_state.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).clearChat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18
            )),
        centerTitle: true,
        backgroundColor:  const Color(0xffFFBB2B),
        elevation: 0.0,
      ),
      body: BlocBuilder<AppCubit,AppState>(
        builder: (context,state){
          var cubit =AppCubit.get(context);
          return Column(
            children: [
              Expanded(child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(cubit.listChat.length, (index) =>Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                      child: Row(
                        mainAxisAlignment:(cubit.listChat[index].isOwner??false)?MainAxisAlignment.start: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                    decoration: BoxDecoration(
                                        color: (cubit.listChat[index].isOwner??false)?Colors.white:const Color(0xffFFBB2B),
                                        borderRadius:
                                        BorderRadius.circular(8)
                                    ),
                                    child: Text(cubit.listChat[index].msg??'',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: (cubit.listChat[index].isOwner??false)?Colors.black:Colors.white),)
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ))

                  ],
                ),
              )),
              TextFormField(
                onEditingComplete: (){
                },
                textInputAction:TextInputAction.done,
                keyboardType:TextInputType.text ,
                controller: msgController,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  hintText: 'Add Massage',

                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (state is LoadingChatState)?
                      const CircularProgressIndicator():InkWell(
                          onTap: ()async{
                            if(msgController.text.isNotEmpty){
                              cubit.addChat(msgController.text);
                              cubit.chatBot(msg: msgController.text);
                            }
                            msgController.clear();
                          },
                          child: const Icon(Icons.send,color: Colors.grey,size: 18,)),
                      const SizedBox(width: 5,),
                    ],
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:const  EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder:InputBorder.none,
                ),
              ),
            ],
          );
        },
      )
    );
  }
}

class ChatModel{
  bool ? isOwner;
  String ? msg;

  ChatModel({this.msg, this.isOwner});

  factory ChatModel.jsonData(data){
    return ChatModel(
      msg: data['msg'],
      isOwner: data['isOwner'],
    );
  }

}





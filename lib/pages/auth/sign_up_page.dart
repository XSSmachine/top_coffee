import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../base/custom_loader.dart';
import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/signup_body_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/big_text.dart';



class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var surnameController = TextEditingController();

    var signUpImages = [
      "t.png",
      "f.png",
      "g.png"
    ];

    void _registration(AuthController authController){

      String name = nameController.text.trim();
      String surname = surnameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if(name.isEmpty){
        showCustomSnackBar("Type in your first name",title: "First name");
      }else if(surname.isEmpty){
        showCustomSnackBar("Type in your last name",title: "Last name");
      }else if (email.isEmpty){
        showCustomSnackBar("Type in your email address",title: "Email address");
      }else if (!GetUtils.isEmail(email)){
        showCustomSnackBar("Type in a valid email address",title: "Valid email address");
      }else if(password.isEmpty){
        showCustomSnackBar("Type in your password",title: "Password");
      }else if(password.length<3){
        showCustomSnackBar("Password needs to be at least 3 characters long",title: "Password");
      }else{
        SignupBody signUpBody = SignupBody(
            name: name,
            surname: surname,
            email: email,
            password: password);
        authController.registration(signUpBody).then((status){
          if(status.isSuccess){
            print("Success registration");
            Get.toNamed(RouteHelper.getInitial());
          }else{
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(
        builder: (_authController){
          return !_authController.isLoading?SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: Dimensions.screenHeight*0.05,),
                //app logo
                Container(
                  height: Dimensions.screenHeight*0.25,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80,
                      backgroundImage: AssetImage("/Users/karlokovacevic/Documents/top_coffee/assets/image/coffeecoffee.png"),
                    ),
                  ),
                ),
                //your email
                AppTextField(textController: emailController, hintText: "Email", icon: Icons.email),
                SizedBox(height: Dimensions.height20,),
                //your password
                AppTextField(textController: passwordController, hintText: "Password", icon: Icons.password_sharp,isObscure: true,),
                SizedBox(height: Dimensions.height20,),
                // your name
                AppTextField(textController: nameController, hintText: "Name", icon: Icons.person),
                SizedBox(height: Dimensions.height20,),
                //your phone
                AppTextField(textController: surnameController, hintText: "Surname", icon: Icons.accessibility_sharp),
                SizedBox(height: Dimensions.height20,),

                GestureDetector(
                  onTap: (){
                    _registration(_authController);
                  },
                  child: Container(
                    width: Dimensions.screenWidth/2,
                    height: Dimensions.screenHeight/14,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor
                    ),
                    child: Center(
                      child: BigText(
                        text: "Sign up",
                        size: Dimensions.font20+Dimensions.font20/2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height10,),
                RichText(
                  //clickable text
                    text: TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                        text: "Have an account already?",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.font20
                        )
                    )),
                SizedBox(height: Dimensions.screenHeight*0.05,),
                RichText(
                  //clickable text
                    text: TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                        text: "Use one of the following methods",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.font16
                        )
                    )),
                Wrap(
                  children: List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: Dimensions.radius30,
                      backgroundImage: AssetImage(
                          "/Users/karlokovacevic/Documents/top_coffee/assets/image/"+signUpImages[index]
                      ),
                    ),
                  )),
                )
              ],

            ),
          ):const CustomLoader();
        }
      ),
    );


  }
}

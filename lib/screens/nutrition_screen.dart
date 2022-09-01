import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/models/food_day_wise.dart';
import 'package:poshan/models/food_details.dart';
import 'package:poshan/models/teacher.dart';
import 'package:poshan/providers/food_details_provider.dart';
import 'package:poshan/screens/add_food_screen.dart';
import 'package:poshan/services/firebase_service.dart';
import 'package:poshan/services/prefs_helper.dart';
import 'package:poshan/services/utils.dart';
import 'package:poshan/widgets/circular_step_progress_indicator.dart';
import 'package:poshan/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({Key? key}) : super(key: key);

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {

  bool isLoading = false;
  Teacher? teacher;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    PrefsHelper().getParsedList().then((value) {
      value.forEach((element) {
        Provider.of<FoodDetailsProvider>(context, listen: false).setFoodDetails(element);
      });
      PrefsHelper().getTeacher().then((teach) {
        setState(() {
          teacher = teach;
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.WHITE,
        iconTheme: const IconThemeData(
          color: ConstantColors.BLACK,
        ),
        title: const Text(
          'Nutrition',
          style: TextStyle(
            color: ConstantColors.BLACK,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3.0,
                  child: ListTile(
                    leading: CircularStepProgressIndicator(
                      totalSteps: 10,
                      currentStep: 0,
                      stepSize: 5,
                      selectedColor: ConstantColors.RED,
                      unselectedColor: Colors.grey[200],
                      padding: 0,
                      width: height * 0.06,
                      height: height * 0.06,
                      roundedCap: (_, __) => true,
                      child: const Center(
                        child: Icon(Icons.food_bank),
                      ),
                    ),
                    title: Text(
                      '${context.watch<FoodDetailsProvider>().getTotalCalories()} of 700',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Cal Eaten',
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddFoodScreen()));
                      },
                      child: const Text(
                        'Add Meal',
                        style: TextStyle(
                          color: ConstantColors.RED,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: width / 30.0,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: context
                      .watch<FoodDetailsProvider>()
                      .getFoodDetails()
                      .length,
                  itemBuilder: (_, index) {
                    Parsed parsed = context
                        .watch<FoodDetailsProvider>()
                        .getFoodDetails()
                        .elementAt(index);
                    return Card(
                      elevation: 3.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(
                              parsed.food.label,
                              style: const TextStyle(
                                color: ConstantColors.BLACK,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Protein: ${parsed.food.nutrients.procnt}g',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${parsed.food.nutrients.enercKcal} Cal',
                                  style: const TextStyle(
                                    color: ConstantColors.BLACK,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    PrefsHelper().removeParsedFromList(index);
                                    Provider.of<FoodDetailsProvider>(context, listen: false).removeFoodDetailsAt(index);
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: ConstantColors.RED,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: ConstantColors.WHITE,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.camera, color: ConstantColors.BLACK,),
                                SizedBox(
                                  width: width / 30.0,
                                ),
                                const Text(
                                  'Capture Image',
                                  style: TextStyle(
                                    color: ConstantColors.BLACK,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: width / 10.0,
                ),
                context.watch<FoodDetailsProvider>().getFoodDetails().isEmpty ? Container() : Center(
                  child: CustomButton(
                    onTap: () {
                      List<Parsed> parsedList = Provider.of<FoodDetailsProvider>(context, listen: false).getFoodDetails();
                      PrefsHelper().saveParsedList(parsedList);
                      List<FoodDayWise> foodDayWiseList = [];
                      for (Parsed parsed in parsedList) {
                        foodDayWiseList.add(FoodDayWise(
                            name: parsed.food.label,
                            calorie: parsed.food.nutrients.enercKcal,
                            protein: parsed.food.nutrients.procnt,
                            imageFromApi: parsed.food.image,
                          )
                        );
                      }
                      FirebaseService().saveFoodsInFirestore(teacher!.stateName, teacher!.districtName, teacher!.schoolName, foodDayWiseList);
                      Utils().showToast('Meals Saved Successfully');
                    },
                    text: 'SUBMIT',
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

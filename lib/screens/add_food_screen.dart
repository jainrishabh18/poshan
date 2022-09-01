import 'package:flutter/material.dart';
import 'package:poshan/constants/constant_colors.dart';
import 'package:poshan/models/food_details.dart';
import 'package:poshan/providers/food_details_provider.dart';
import 'package:poshan/services/api_service.dart';
import 'package:poshan/services/utils.dart';
import 'package:provider/provider.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  FoodDetails? foodDetails = null;
  bool isLoading = false;

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
          'Add Meal',
          style: TextStyle(
            color: ConstantColors.BLACK,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.01, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (meal) {
                    if (meal.isEmpty) {
                      setState(() {
                        foodDetails = null;
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      ApiService().getFoodDetails(meal).then((value) {
                        print('value : ${value.toString()}');
                        setState(() {
                          foodDetails = value;
                          isLoading = false;
                        });
                      }).catchError((onError) {
                        print('error : ${onError.toString()}');
                        isLoading = false;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Food',
                    hintStyle: const TextStyle(
                      color: ConstantColors.GREY,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ConstantColors.BLACK,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ConstantColors.BLACK,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ConstantColors.RED,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: ConstantColors.RED,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: width / 30.0,
                ),
                foodDetails == null
                    ? Container()
                    : isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: ConstantColors.RED,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: foodDetails!.parsed.length,
                            itemBuilder: (_, index) {
                              Parsed parsed =
                                  foodDetails!.parsed.elementAt(index);
                              return Card(
                                elevation: 3.0,
                                child: ListTile(
                                  title: Text(
                                    '${parsed.food.label}',
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
                                          Provider.of<FoodDetailsProvider>(
                                                  context,
                                                  listen: false)
                                              .setFoodDetails(parsed);
                                          Utils().showToast('Meal Added');
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: ConstantColors.RED,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

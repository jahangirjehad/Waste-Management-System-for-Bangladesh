import 'package:flutter/material.dart';
import 'package:maps_app/Model/userModel.dart';
import 'package:maps_app/View/Profile/sellingPage.dart';
import 'package:maps_app/utils/my_colors.dart';
import 'package:simple_animated_button/simple_animated_button.dart';

class CompanyProfile extends StatelessWidget {
  final RecyclingCompany recyclingCompany;

  const CompanyProfile({Key? key, required this.recyclingCompany})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle monoStyle = const TextStyle(
      fontSize: 18,
      fontFamily: 'Fira Mono',
      color: Colors.black,
      fontWeight: FontWeight.w900,
    );

    return Scaffold(
      backgroundColor: MyColors.caribbeanGreenTint7,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height:
                    MediaQuery.of(context).size.width, // Make the image square
                child: Material(
                  elevation: 3.0, // Set the elevation
                  clipBehavior:
                      Clip.antiAlias, // Ensure the clip behavior is applied
                  child: InkWell(
                    onTap: () {
                      // Handle the tap event
                      print('Image tapped!');
                    },
                    child: Ink(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: MyColors.caribbeanGreenTint5,
                      ),
                      child: Image.network(
                        recyclingCompany.image,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        fit: BoxFit
                            .cover, // Ensure the image covers the entire area
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                recyclingCompany.companyName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildContactInfo(
                icon: Icons.phone,
                label: recyclingCompany.mobile,
                color: MyColors.yelpRed,
                context: context,
              ),
              buildContactInfo(
                icon: Icons.email,
                label: recyclingCompany.email,
                color: MyColors.caribbeanGreen,
                context: context,
              ),
              buildContactInfo(
                icon: Icons.location_on,
                label: recyclingCompany.address,
                color: MyColors.vividCerulean,
                context: context,
                isAddress: true,
              ),
              SizedBox(height: 15),
              Center(
                child: ElevatedLayerButton(
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelllingFormScreen(
                              recyclingCompany: recyclingCompany)),
                    );
                  },
                  buttonHeight: 60,
                  buttonWidth: 270,
                  animationDuration: const Duration(milliseconds: 200),
                  animationCurve: Curves.ease,
                  topDecoration: BoxDecoration(
                    color: Colors.amber,
                    border: Border.all(),
                  ),
                  topLayerChild: Text(
                    "বিক্রয় করুন",
                    style: monoStyle,
                  ),
                  baseDecoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Column(
                children: recyclingCompany.wasteCategories.entries.map((entry) {
                  return buildCategoryRow(entry.key, entry.value, context);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContactInfo({
    required IconData icon,
    required String label,
    required Color color,
    required BuildContext context,
    bool isAddress = false,
  }) {
    return InkWell(
      onTap: () {
        // Handle contact info tap
        print('$label tapped!');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24.0,
            color: color,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16.0),
              overflow: isAddress ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryRow(String title, String price, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.recycling,
                color: MyColors.firstColor,
                size: 24.0,
              ),
              SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(color: MyColors.firstColor, fontSize: 15),
              ),
            ],
          ),
          Text(
            "Price: $price",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: MyColors.caribbeanGreen,
            ),
          ),
        ],
      ),
    );
  }
}

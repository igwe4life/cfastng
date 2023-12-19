import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop_example/constants.dart';
// Import the AdMob package
import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:shop_example/widgets/AdManager.dart';
import 'package:shop_example/widgets/CustomBannerAd.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kcontentColor,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 5,
          ),
          child: Row(
            children: [
              const Icon(
                Ionicons.search,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              const Flexible(
                flex: 4,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 25,
                width: 1.5,
                color: Colors.grey,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Ionicons.options_outline,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        // Add the AdMob banner here
        Container(
          height: 50, // Set your desired height
          alignment: Alignment.center,
          child: const CustomBannerAd(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CallButtonsBar extends StatelessWidget {
  final VoidCallback onRequestCallPressed;
  final VoidCallback onMakeCallPressed;

  const CallButtonsBar({
    Key? key,
    required this.onRequestCallPressed,
    required this.onMakeCallPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.center, // Center the buttons
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the buttons horizontally
          children: [
            SizedBox(
              width: 150, // Set a fixed width for the buttons
              child: ElevatedButton(
                onPressed: onRequestCallPressed,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                  side: BorderSide(color: Colors.blue), // Adding border
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // Adding border radius
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call), // Add the call icon
                    SizedBox(
                        width: 5), // Add some spacing between icon and text
                    Text(
                      'Request Call',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10), // Add a SizedBox with width 10 for separation
            SizedBox(
              width: 150, // Set a fixed width for the buttons
              child: ElevatedButton(
                onPressed: onMakeCallPressed,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                  side: BorderSide(color: Colors.blue), // Adding border
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // Adding border radius
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call), // Add the call icon
                    SizedBox(
                        width: 5), // Add some spacing between icon and text
                    Text(
                      'Call',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

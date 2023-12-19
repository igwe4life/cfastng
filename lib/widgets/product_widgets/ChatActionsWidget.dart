import 'package:flutter/material.dart';

class ChatActionsWidget extends StatefulWidget {
  final VoidCallback onMakeOfferPressed;
  final VoidCallback onIsAvailablePressed;
  final VoidCallback onLastPricePressed;
  final TextEditingController textEditingController;
  final VoidCallback onStartChatPressed;

  ChatActionsWidget({
    required this.onMakeOfferPressed,
    required this.onIsAvailablePressed,
    required this.onLastPricePressed,
    required this.textEditingController,
    required this.onStartChatPressed,
  });

  @override
  _ChatActionsWidgetState createState() => _ChatActionsWidgetState();
}

class _ChatActionsWidgetState extends State<ChatActionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button background color
                  onPrimary: Colors.white, // Text color
                  side: BorderSide(color: Colors.blue), // Border color
                ),
                onPressed: () {
                  setState(() {
                    widget.textEditingController.text = 'Make an Offer';
                  });
                  widget.onMakeOfferPressed();
                },
                child: const Text(
                  'Make an Offer',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  side: BorderSide(color: Colors.blue),
                ),
                onPressed: () {
                  setState(() {
                    widget.textEditingController.text = 'Is This Available';
                  });
                  widget.onIsAvailablePressed();
                },
                child: const Text(
                  'Is This Available',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  side: BorderSide(color: Colors.blue),
                ),
                onPressed: () {
                  setState(() {
                    widget.textEditingController.text = 'Last Price';
                  });
                  widget.onLastPricePressed();
                },
                child: const Text(
                  'Last Price',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: widget.textEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.blue), // TextField border color
            ),
            hintText: 'Type your message...',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: widget.onStartChatPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: const Text('Start Chat'),
        ),
      ],
    );
  }
}

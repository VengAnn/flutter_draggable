import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Offset> _positions = [
    const Offset(20, 20), // Initial position for the draggable object
  ];

  final List<String> _textValues = [
    'Element 1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Section 1: Draggable Objects Section
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _positions
                              .add(const Offset(20, 20)); // New object position
                          _textValues.add(
                              'New Element'); // Default text for the new element
                        });
                      },
                      child: const Text('Add Object'),
                    ),
                  ],
                ),
              ),
            ),

            // Section 2: Drop Zone Section
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  border: Border.all(
                    width: 1,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        for (int i = 0; i < _positions.length; i++)
                          Positioned(
                            top: _positions[i].dy,
                            left: _positions[i].dx,
                            child: Draggable(
                              feedback: _buildDraggableChip(_textValues[i]),
                              onDragEnd: (details) {
                                if (kDebugMode) {
                                  print('Global Position: ${details.offset}');
                                }

                                // Get the bounds of the parent drop zone
                                final RenderBox dropZoneBox =
                                    context.findRenderObject() as RenderBox;
                                final Offset localOffset =
                                    dropZoneBox.globalToLocal(details.offset);

                                setState(() {
                                  // Constrain the position to stay within the drop zone
                                  // Assuming Chip width of 50
                                  double newX = localOffset.dx.clamp(
                                    0.0,
                                    constraints.maxWidth - 50,
                                  );
                                  // Assuming Chip height of 30
                                  double newY = localOffset.dy.clamp(
                                    0.0,
                                    constraints.maxHeight - 30,
                                  );

                                  // Restrict horizontal (dx) movement to a maximum of 1054
                                  newX = newX.clamp(0.0, 1054.0);

                                  // Restrict vertical (dy) movement to a maximum of 532
                                  newY = newY.clamp(0.0, 532.0);

                                  _positions[i] = Offset(newX, newY);
                                });

                                log('Local Position: ${_positions[i]}');
                              },
                              child: GestureDetector(
                                onTap: () async {
                                  final result =
                                      await _editTextDialog(_textValues[i]);
                                  if (result != null) {
                                    setState(() {
                                      _textValues[i] = result;
                                    });
                                  }
                                },
                                onLongPress: () {
                                  setState(() {
                                    _positions.removeAt(i);
                                    _textValues.removeAt(i);
                                  });
                                },
                                child: _buildDraggableChip(_textValues[i]),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to create a Draggable Chip with a given text
  Widget _buildDraggableChip(String text) {
    return Material(
      child: Chip(
        label: Text(text),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  /// Helper method to display a dialog for editing text of an object
  Future<String?> _editTextDialog(String initialValue) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Text'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new text'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

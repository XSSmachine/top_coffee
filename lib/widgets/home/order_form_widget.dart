import 'package:flutter/material.dart';

class CoffeeOrderWidget extends StatefulWidget {
  final List<String> coffeeTypes;
  final List<IconData> coffeeIcons; // New parameter for icons
  final Function(String, int, int) onOrderPlaced;
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final Color buttonColor;

  const CoffeeOrderWidget({
    super.key,
    required this.coffeeTypes,
    required this.coffeeIcons, // Initialize the icons list
    required this.onOrderPlaced,
    this.backgroundColor = Colors.greenAccent,
    this.textColor = Colors.white,
    this.accentColor = Colors.red,
    this.buttonColor = Colors.teal,
  });

  @override
  _CoffeeOrderWidgetState createState() => _CoffeeOrderWidgetState();
}

class _CoffeeOrderWidgetState extends State<CoffeeOrderWidget> {
  late String selectedCoffeeType;
  int _selectedMilkQuantity = 0;
  int _selectedSugarQuantity = 0;

  @override
  void initState() {
    super.initState();
    selectedCoffeeType = widget.coffeeTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.greenAccent,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Coffee Order",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedCoffeeType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCoffeeType = newValue!;
                  });
                },
                items: widget.coffeeTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        const Icon(Icons.coffee),
                        const SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Milk Quantity:",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 2,
                children: [
                  for (int i = 0; i <= 5; i++)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedMilkQuantity = i;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedMilkQuantity == i ? Colors.blue : Colors.grey,
                      ),
                      child: Text("$i"),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Sugar Quantity:",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: 2,
                children: [
                  for (int i = 0; i <= 5; i++)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedSugarQuantity = i;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedSugarQuantity == i ? Colors.blue : Colors.grey,
                      ),
                      child: Text("$i"),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // ... (keep the existing code)
                },
                child: const Text("Order Up!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

      /*
      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Coffee Order",
            style: TextStyle(color: widget.textColor, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildDropdown(),
          SizedBox(height: 20),
          _buildQuantitySelector("Milk", _selectedMilkQuantity, (value) => _selectedMilkQuantity = value),
          SizedBox(height: 20),
          _buildQuantitySelector("Sugar", _selectedSugarQuantity, (value) => _selectedSugarQuantity = value),
          SizedBox(height: 30),
          _buildOrderButton(),
        ],
      ),
    );
  }

       */

  /*
  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Coffee Type:",
          style: TextStyle(color: widget.textColor, fontSize: 18),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.textColor.withOpacity(0.1),
          ),
          child: DropdownButton<String>(
            value: selectedCoffeeType,
            onChanged: (String? newValue) {
              setState(() {
                selectedCoffeeType = newValue!;
              });
            },
            items: widget.coffeeTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: widget.textColor)),
              );
            }).toList(),
            dropdownColor: widget.backgroundColor,
            style: TextStyle(color: widget.textColor),
            icon: Icon(Icons.arrow_drop_down, color: widget.textColor),
            isExpanded: true,
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(String label, int selectedQuantity, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select $label Quantity:",
          style: TextStyle(color: widget.textColor, fontSize: 18),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i <= 5; i++)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    onChanged(i);
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: selectedQuantity == i ? widget.accentColor : widget.buttonColor,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(12),
                  minimumSize: Size(30, 30)
                ),
                child: Text("$i", style: TextStyle(color: widget.textColor)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          widget.onOrderPlaced(selectedCoffeeType, _selectedMilkQuantity, _selectedSugarQuantity);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: widget.accentColor,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          "Order Up!",
          style: TextStyle(fontSize: 18, color: widget.textColor),
        ),
      ),
    );
  }

   */

import 'package:flutter/material.dart';

class DatepickerInput extends StatelessWidget {
  const DatepickerInput({super.key, required this.dateController});

  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null;
        }

        final parts = value.split('/');

        if (parts.length != 3) {
          return 'Formato inválido';
        }

        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day == null || month == null || year == null) {
          return 'Fecha inválida';
        }

        final selectedDate = DateTime(year, month, day);

        final today = DateTime.now();

        final normalizedToday = DateTime(today.year, today.month, today.day);

        if (selectedDate.isBefore(normalizedToday)) {
          return 'La fecha no puede ser anterior a hoy';
        }

        return null;
      },
      controller: dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Fecha expiración',
        hintText: 'DD/MM/AAAA',
        filled: true,
        fillColor: Colors.grey.shade100,
        prefixIcon: Icon(Icons.calendar_month),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        );

        if (pickedDate != null) {
          dateController.text =
              '${pickedDate.day.toString().padLeft(2, '0')}/'
              '${pickedDate.month.toString().padLeft(2, '0')}/'
              '${pickedDate.year}';
        }
      },
    );
  }
}

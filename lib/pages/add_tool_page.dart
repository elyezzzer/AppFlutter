import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddToolPage extends StatefulWidget {
  @override
  _AddToolPageState createState() => _AddToolPageState();
}

class _AddToolPageState extends State<AddToolPage> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _brandController = TextEditingController();
  final _voltageController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _category = 'Manual';
  bool _showVoltage = false;

  // SE A FERRAMENTA FOR ELETRICA, MOSTRA O CAMPO DE VOLTAGEM
  void _updateCategory(String value) {
    setState(() {
      _category = value;
      _showVoltage = value == 'Elétrica';
      if (!_showVoltage) _voltageController.clear();
    });
  }

  // FUNCAO PARA SALVAR A FERRAMENTA
  void _saveTool() async {
    // VALIDA SE NOME E CODIGO FORAM PREENCHIDOS
    if (_nameController.text.isEmpty || _codeController.text.isEmpty) {
      _showMessage('Nome e código são obrigatórios!');
      return;
    }
    // VALIDA SE VOLTAGEM FOI PREENCHIDA (CASO SEJA ELÉTRICA)
    if (_category == 'Elétrica' && _voltageController.text.isEmpty) {
      _showMessage('A voltagem é obrigatória!');
      return;
    }

    // SALVA NO FIREBASE
    try {
      await FirebaseFirestore.instance.collection('tools').add({
        'name': _nameController.text,
        'code': _codeController.text,
        'brand': _brandController.text,
        'category': _category,
        'voltage': _voltageController.text,
        'description': _descriptionController.text,
        'isAvailable': true,
        'borrowedBy': null,
        'borrowedDate': null,
      });
      Navigator.pop(context);
      _showMessage('Ferramenta adicionada com sucesso!', isError: false);
    } catch (e) {
      _showMessage('Erro ao salvar: $e');
    }
  }

  // FUNCAO PARA MOSTRAR MENSAGEM
  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // CAMPO DE TEXTO REUTILIZAVEL
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Ferramenta')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // MENU DROPDOWN DE CATEGORIA
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
              items: ['Manual', 'Elétrica'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => _updateCategory(value!),
            ),
            
            SizedBox(height: 16),
            _buildTextField(_nameController, 'Nome da ferramenta*'),
            SizedBox(height: 16),
            _buildTextField(_codeController, 'Código*'),
            SizedBox(height: 16),
            _buildTextField(_brandController, 'Marca'),
            
            // VOLTAGEM (CONDICIONAL)
            if (_showVoltage) ...[
              SizedBox(height: 16),
              _buildTextField(_voltageController, 'Voltagem*'),
            ],
            
            SizedBox(height: 16),
            _buildTextField(_descriptionController, 'Descrição', maxLines: 3),
            SizedBox(height: 20),
            
            // BOTÃO SALVAR
            ElevatedButton(
              onPressed: _saveTool,
              child: Text('Salvar Ferramenta'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
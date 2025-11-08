import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableToolsPage extends StatelessWidget {

  // FUNÇÃO ÚNICA PARA MENSAGENS
  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // FUNÇÃO ÚNICA PARA OPERAÇÕES FIREBASE
  Future<void> _firebaseOperation(BuildContext context, Future Function() operation, String successMsg) async {
    try {
      await operation();
      _showMessage(context, successMsg);
    } catch (e) {
      print('Erro: $e');
      _showMessage(context, 'Erro: $e', isError: true);
    }
  }

  // FUNÇÃO PARA DELETAR FERRAMENTA
  void _deleteTool(BuildContext context, String toolId, String toolName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Deletar Ferramenta'),
      content: Text('Deletar "$toolName"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {  
            Navigator.pop(context); 
            await _firebaseOperation(  
              context,
              () => FirebaseFirestore.instance.collection('tools').doc(toolId).delete(),
              'Ferramenta deletada!'
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text('Deletar'),
        ),
      ],
    ),
  );
}

  // FUNÇÃO PARA EMPRESTAR FERRAMENTA
  void _borrowTool(BuildContext context, String toolId, String toolName) {
  final nameController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Emprestar $toolName'),
      content: TextField(
        controller: nameController,
        decoration: InputDecoration(labelText: 'Nome da pessoa'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {  
            if (nameController.text.isEmpty) {
              _showMessage(context, 'Digite um nome', isError: true);
              return;
            }
            Navigator.pop(context); 
            await _firebaseOperation(  
              context,
              () => FirebaseFirestore.instance.collection('tools').doc(toolId).update({
                'isAvailable': false,
                'borrowedBy': nameController.text,
                'borrowedDate': DateTime.now().toIso8601String(),
              }),
              'Ferramenta emprestada!'
            );
          },
          child: Text('Emprestar'),
        ),
      ],
    ),
  );
}

  // FUNÇÃO PARA EDITAR FERRAMENTA
  void _editTool(BuildContext context, QueryDocumentSnapshot tool) {
  final data = tool.data() as Map<String, dynamic>;
  final nameController = TextEditingController(text: data['name'] ?? '');
  final brandController = TextEditingController(text: data['brand'] ?? '');
  final voltageController = TextEditingController(text: data['voltage'] ?? '');
  final codeController = TextEditingController(text: data['code'] ?? '');
  final descController = TextEditingController(text: data['description'] ?? '');
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Editar ${data['name']}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome*'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: 'Código*'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: voltageController,
              decoration: InputDecoration(labelText: 'Voltagem'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: descController,
              maxLines: 2,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (nameController.text.isEmpty || codeController.text.isEmpty) {
              _showMessage(context, 'Nome e código são obrigatórios!');
              return;
            }

            Navigator.pop(context);
            await _firebaseOperation( 
              context,
              () => FirebaseFirestore.instance.collection('tools').doc(tool.id).update({
                'name': nameController.text,
                'code': codeController.text,
                'brand': brandController.text,
                'voltage': voltageController.text,
                'description': descController.text,
              }),
              'Ferramenta atualizada!'
            );
          },
          child: Text('Salvar'),
        ),
      ],
    ),
  );
}

  // CARD DA FERRAMENTA
  Widget _buildToolCard(BuildContext context, QueryDocumentSnapshot tool) {
    final data = tool.data() as Map<String, dynamic>;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['name'] ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (data['brand']?.isNotEmpty == true) Text(data['brand'],),
                SizedBox(height: 4),
                Text('Código: ${data['code'] ?? ''}',style: TextStyle(color: Colors.grey[600])),
                if (data['voltage']?.isNotEmpty == true) Text('Voltagem: ${data['voltage']}',style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 4),
                if (data['description']?.isNotEmpty == true) Text(
                  'Descrição: ${data['description']}',
                  style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 12),

            // BOTOES DE ACAO (EDITAR, EMPRESTAR, DELETAR)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _deleteTool(context, tool.id, data['name'] ?? ''),
                    tooltip: 'Deletar ferramenta',
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _editTool(context, tool),
                    tooltip: 'Editar ferramenta',
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () => _borrowTool(context, tool.id, data['name'] ?? ''),
                    tooltip: 'Emprestar ferramenta',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // METODO CONSTRUTOR DO WIDGET
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tools')
          .where('isAvailable', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Nenhuma ferramenta disponível'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => _buildToolCard(context, snapshot.data!.docs[index]),
        );
      },
    );
  }
}
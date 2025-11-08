import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowedToolsPage extends StatelessWidget {

  // FUNÇÃO ÚNICA PARA MENSAGENS
  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  // FUNÇÃO ÚNICA PARA OPERAÇÕES FIREBASE
  Future<void> _firebaseOperation(BuildContext context, Future Function() operation, String successMsg) async {
    try {
      await operation();
      _showMessage(context, successMsg);
    } catch (e) {
      _showMessage(context, 'Erro: $e', isError: true);
    }
  }

  // DEVOLVER FERRAMENTA
  void _returnTool(BuildContext context, String toolId, String toolName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Devolver Ferramenta'),
        content: Text('Devolver "$toolName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _firebaseOperation(
                context,
                () => FirebaseFirestore.instance.collection('tools').doc(newMethod(toolId)).update({
                  'isAvailable': true,
                  'borrowedBy': null,
                  'borrowedDate': null,
                }),
                'Ferramenta devolvida!'
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Devolver'),
          ),
        ],
      ),
    );
  }

  String newMethod(String toolId) => toolId;

  // FORMATAR DATA PARA PADRÃO BRASIL
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString).toLocal();
      return '${date.day}/${date.month}/${date.year} ${date.hour}h${date.minute}';
    } catch (e) {
      return 'Data inválida';
    }
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
                if (data['brand']?.isNotEmpty == true) 
                  Text(data['brand'], style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 8),
                Text('Código: ${data['code'] ?? ''}',style: TextStyle(color: Colors.grey[600])),
                if (data['description']?.isNotEmpty == true) Text(
                  'Descrição: ${data['description']}',
                  style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text('Emprestado para: ${data['borrowedBy'] ?? ''}', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                if (data['borrowedDate'] != null)
                  Text('Data: ${_formatDate(data['borrowedDate'])}', 
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 12),
            // BOTÃO DEVOLVER
            Row(
              
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.check, color: Colors.white),
                    onPressed: () => _returnTool(context, tool.id, data['name'] ?? ''),
                    tooltip: 'Devolver ferramenta',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tools')
          .where('isAvailable', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Nenhuma ferramenta emprestada'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => _buildToolCard(context, snapshot.data!.docs[index]),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/document_category_widget.dart';
import './widgets/empty_documents_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/storage_usage_indicator_widget.dart';
import './widgets/upload_bottom_sheet_widget.dart';

class DocumentsManagerScreen extends StatefulWidget {
  const DocumentsManagerScreen({super.key});

  @override
  State<DocumentsManagerScreen> createState() => _DocumentsManagerScreenState();
}

class _DocumentsManagerScreenState extends State<DocumentsManagerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _documents = [];
  List<Map<String, dynamic>> _filteredDocuments = [];
  String _selectedFilter = 'All';
  final bool _isOfflineMode = false;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  void _loadDocuments() {
    // Mock data - replace with actual API call
    _documents = [
      {
        'id': '1',
        'name': 'Lease Agreement - Oak Street.pdf',
        'type': 'lease',
        'category': 'Leases',
        'size': '2.4 MB',
        'date': DateTime.now().subtract(Duration(days: 5)),
        'thumbnail':
            'https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg',
        'isSecure': true,
        'propertyId': 'prop1',
        'propertyName': 'Oak Street Apartment',
        'downloadProgress': null,
        'isOfflineAvailable': true,
      },
      {
        'id': '2',
        'name': 'Tenant Application - John Doe.pdf',
        'type': 'application',
        'category': 'Applications',
        'size': '1.8 MB',
        'date': DateTime.now().subtract(Duration(days: 12)),
        'thumbnail':
            'https://images.pixabay.com/photo/2016/11/29/06/18/document-1867616_1280.jpg',
        'isSecure': false,
        'propertyId': 'prop2',
        'propertyName': 'Maple Avenue House',
        'downloadProgress': null,
        'isOfflineAvailable': false,
      },
      {
        'id': '3',
        'name': 'Property Inspection Report.pdf',
        'type': 'property',
        'category': 'Property Documents',
        'size': '5.2 MB',
        'date': DateTime.now().subtract(Duration(days: 3)),
        'thumbnail':
            'https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=500',
        'isSecure': false,
        'propertyId': 'prop1',
        'propertyName': 'Oak Street Apartment',
        'downloadProgress': 0.7,
        'isOfflineAvailable': false,
      },
      {
        'id': '4',
        'name': 'Monthly Financial Report.xlsx',
        'type': 'financial',
        'category': 'Financial Records',
        'size': '892 KB',
        'date': DateTime.now().subtract(Duration(days: 1)),
        'thumbnail':
            'https://images.pexels.com/photos/590022/pexels-photo-590022.jpeg',
        'isSecure': true,
        'propertyId': null,
        'propertyName': 'All Properties',
        'downloadProgress': null,
        'isOfflineAvailable': true,
      },
    ];
    _filteredDocuments = List.from(_documents);
  }

  void _filterDocuments(String query) {
    setState(() {
      _filteredDocuments = _documents.where((doc) {
        final name = doc['name'].toString().toLowerCase();
        final category = doc['category'].toString().toLowerCase();
        final property = doc['propertyName'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            category.contains(searchQuery) ||
            property.contains(searchQuery);
      }).toList();
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => UploadBottomSheetWidget(
        onCameraCapture: _handleCameraCapture,
        onPhotoLibrary: _handlePhotoLibrary,
        onFilePicker: _handleFilePicker,
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheetWidget(
        selectedFilter: _selectedFilter,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
            _applyFilter();
          });
        },
      ),
    );
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == 'All') {
        _filteredDocuments = List.from(_documents);
      } else {
        _filteredDocuments = _documents
            .where((doc) => doc['category'] == _selectedFilter)
            .toList();
      }
    });
  }

  void _handleCameraCapture() {
    Navigator.pop(context);
    // Implement camera capture
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Camera capture initiated')),
    );
  }

  void _handlePhotoLibrary() {
    Navigator.pop(context);
    // Implement photo library access
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Photo library opened')),
    );
  }

  void _handleFilePicker() {
    Navigator.pop(context);
    // Implement file picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File picker opened')),
    );
  }

  void _handleDocumentTap(Map<String, dynamic> document) {
    // Open document viewer with annotation tools
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${document['name']}')),
    );
  }

  void _handleDocumentShare(Map<String, dynamic> document) {
    // Implement document sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${document['name']}')),
    );
  }

  void _handleDocumentDelete(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document'),
        content: Text('Are you sure you want to delete "${document['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _documents.removeWhere((doc) => doc['id'] == document['id']);
                _filteredDocuments
                    .removeWhere((doc) => doc['id'] == document['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Document deleted')),
              );
            },
            child: Text('Delete', style: TextStyle(color: AppTheme.primaryRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: Text(
          'Documents Manager',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showUploadOptions,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.primaryRed,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage usage indicator
          StorageUsageIndicatorWidget(
            usedStorage: 12.5,
            totalStorage: 50.0,
            isOfflineMode: _isOfflineMode,
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.all(4.w),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDocuments,
              decoration: InputDecoration(
                hintText: 'Search documents, properties...',
                prefixIcon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _filterDocuments('');
                        },
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // Documents list or empty state
          Expanded(
            child: _filteredDocuments.isEmpty
                ? EmptyDocumentsWidget(
                    onUploadPressed: _showUploadOptions,
                  )
                : _buildDocumentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList() {
    // Group documents by category
    Map<String, List<Map<String, dynamic>>> categorizedDocs = {};
    for (var doc in _filteredDocuments) {
      String category = doc['category'];
      if (!categorizedDocs.containsKey(category)) {
        categorizedDocs[category] = [];
      }
      categorizedDocs[category]!.add(doc);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: categorizedDocs.length,
      itemBuilder: (context, index) {
        String category = categorizedDocs.keys.elementAt(index);
        List<Map<String, dynamic>> documents = categorizedDocs[category]!;

        return DocumentCategoryWidget(
          category: category,
          documents: documents,
          onDocumentTap: _handleDocumentTap,
          onDocumentShare: _handleDocumentShare,
          onDocumentDelete: _handleDocumentDelete,
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class PostCategory {
  final String label;
  final String value;

  const PostCategory({required this.label, required this.value});
}

const List<PostCategory> kPostCategories = [
  PostCategory(label: 'Technology', value: 'technology'),
  PostCategory(label: 'Lifestyle', value: 'lifestyle'),
  PostCategory(label: 'Travel', value: 'travel'),
  PostCategory(label: 'Food', value: 'food'),
  PostCategory(label: 'Health', value: 'health'),
  PostCategory(label: 'Education', value: 'education'),
  PostCategory(label: 'Other', value: 'other'),
];
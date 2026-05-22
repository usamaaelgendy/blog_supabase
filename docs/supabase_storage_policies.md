# Supabase Storage — `post-image` Bucket & Policies

Migration name: `create_post_image_bucket_with_policies`
Applied via `mcp__supabase__apply_migration`.

The migration is idempotent — safe to re-run.

## 1. Bucket

Public bucket with a 10 MB per-file limit, no MIME restriction.

```sql
INSERT INTO storage.buckets (id, name, public, file_size_limit)
VALUES ('post-image', 'post-image', true, 10485760)
ON CONFLICT (id) DO UPDATE
SET public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit;
```

## 2. RLS policies on `storage.objects`

All four policies are scoped to `bucket_id = 'post-image'`.
Write policies require the object's top-level folder to match the signed-in user's id, i.e. uploads must use a path like `{auth.uid()}/filename.ext`.

### Drop existing (for idempotency)

```sql
DROP POLICY IF EXISTS "post_image_public_select"          ON storage.objects;
DROP POLICY IF EXISTS "post_image_authenticated_insert"   ON storage.objects;
DROP POLICY IF EXISTS "post_image_authenticated_update"   ON storage.objects;
DROP POLICY IF EXISTS "post_image_authenticated_delete"   ON storage.objects;
```

### SELECT — public read for anyone (anon + authenticated)

```sql
CREATE POLICY "post_image_public_select"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'post-image');
```

### INSERT — authenticated users, own folder only

```sql
CREATE POLICY "post_image_authenticated_insert"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'post-image'
  AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
);
```

### UPDATE — authenticated users, own folder only

```sql
CREATE POLICY "post_image_authenticated_update"
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'post-image'
  AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
)
WITH CHECK (
  bucket_id = 'post-image'
  AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
);
```

### DELETE — authenticated users, own folder only

```sql
CREATE POLICY "post_image_authenticated_delete"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'post-image'
  AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
);
```

## 3. Summary

| Policy | Cmd | Role | Predicate |
|---|---|---|---|
| `post_image_public_select` | SELECT | `public` | `bucket_id = 'post-image'` |
| `post_image_authenticated_insert` | INSERT | `authenticated` | `bucket_id = 'post-image' AND (storage.foldername(name))[1] = auth.uid()::text` (WITH CHECK) |
| `post_image_authenticated_update` | UPDATE | `authenticated` | same folder check (USING + WITH CHECK) |
| `post_image_authenticated_delete` | DELETE | `authenticated` | same folder check (USING) |

## 4. Dart client usage

`lib/core/network/supabase/storage_client_impl.dart` already exposes:

```dart
storage.uploadFile(
  bucket: 'post-image',
  path: '$userId/$postId.jpg', // MUST start with the signed-in user's id
  fileBytes: bytes,
  contentType: 'image/jpeg',
);
```

A path that does not begin with `auth.uid()` will be rejected by the INSERT/UPDATE policy with a 403.

## 5. Verification queries

```sql
-- Bucket
SELECT id, public, file_size_limit
FROM storage.buckets
WHERE id = 'post-image';

-- Policies
SELECT policyname, cmd, roles, qual, with_check
FROM pg_policies
WHERE schemaname = 'storage'
  AND tablename = 'objects'
  AND policyname LIKE 'post_image_%'
ORDER BY policyname;
```
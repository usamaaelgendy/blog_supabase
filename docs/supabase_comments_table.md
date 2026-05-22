# Supabase Database — `comments` Table & Policies

Migration name: `create_comments_table`
Applied via `mcp__supabase__apply_migration`.

## 1. Table

The `comments` table stores user-authored comments on posts. Each row links a post to its author through foreign keys with `ON DELETE CASCADE`, so comments are automatically removed when the parent post or author is deleted.

| Column       | Type                          | Constraints                                                                 |
|--------------|-------------------------------|-----------------------------------------------------------------------------|
| `id`         | `uuid`                        | Primary key, default `gen_random_uuid()`                                    |
| `content`    | `text`                        | `NOT NULL`                                                                  |
| `post_id`    | `uuid`                        | `NOT NULL`, FK → `public.posts(id)` `ON DELETE CASCADE`                     |
| `author_id`  | `uuid`                        | `NOT NULL`, FK → `public.profiles(id)` `ON DELETE CASCADE`                  |
| `created_at` | `timestamp without time zone` | `NOT NULL`, default `now()`                                                 |

> Note: the column is named `author_id` (matching the existing `posts.author_id` convention), not `auther_id`.

```sql
create table public.comments (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  post_id uuid not null references public.posts(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamp not null default now()
);
```

## 2. Indexes

Foreign-key columns are indexed to speed up the common access patterns: listing comments for a post, and looking up comments by a given author.

```sql
create index comments_post_id_idx   on public.comments(post_id);
create index comments_author_id_idx on public.comments(author_id);
```

## 3. Row Level Security

RLS is enabled on the table. The four policies below cover read, create, update, and delete access.

```sql
alter table public.comments enable row level security;
```

### 3.1 SELECT — public read

Anyone (signed-in or anonymous) can read all comments.

```sql
create policy "Comments are viewable by everyone"
  on public.comments
  for select
  to authenticated, anon
  using (true);
```

### 3.2 INSERT — authenticated users only, must be the author

A signed-in user can insert a comment only if `author_id` matches their own `auth.uid()`.

```sql
create policy "Authenticated users can insert their own comments"
  on public.comments
  for insert
  to authenticated
  with check ((select auth.uid()) = author_id);
```

### 3.3 UPDATE — only the author

A user can update a comment only if they are its author. The `with check` clause prevents reassigning ownership during an update.

```sql
create policy "Users can update their own comments"
  on public.comments
  for update
  to authenticated
  using ((select auth.uid()) = author_id)
  with check ((select auth.uid()) = author_id);
```

### 3.4 DELETE — only the author

A user can delete only their own comments.

```sql
create policy "Users can delete their own comments"
  on public.comments
  for delete
  to authenticated
  using ((select auth.uid()) = author_id);
```

## 4. Cascade behavior summary

- Deleting a post (`public.posts`) → all its comments are deleted.
- Deleting a profile (`public.profiles`) → all of that user's comments are deleted. Since `profiles.id` references `auth.users.id`, deleting an auth user also propagates here.

## 5. Verification

After applying the migration, confirm via:

```sql
-- Check structure
select column_name, data_type, is_nullable, column_default
from information_schema.columns
where table_schema = 'public' and table_name = 'comments';

-- Check policies
select policyname, cmd, roles
from pg_policies
where schemaname = 'public' and tablename = 'comments';
```

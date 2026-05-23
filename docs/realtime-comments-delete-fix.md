# Fix: Realtime DELETE Events Not Propagating to Other Devices

## Symptom

After wiring Supabase Realtime for comments:

- Device A adds a comment → device B sees it within ~1s ✅
- Device A deletes a comment → device B **does not** see it disappear ❌
- The Dart subscription on device B never fires its `onChnage` callback for DELETE events.

INSERT works, only DELETE silently fails.

## Root Cause

The DELETE subscription is filtered by `post_id`:

```dart
_realtimeClient.subscribeToTable(
  channelName: 'comments-delete-$postId',
  table: 'comments',
  event: PostgresChangeEvent.delete,
  filterColumn: 'post_id',   // <-- filter
  filterValue: postId,
  onChnage: (payload) { ... },
);
```

Supabase Realtime applies that filter **server-side**, against whatever Postgres ships in the WAL for the deleted row. By default a Postgres table has:

```
REPLICA IDENTITY DEFAULT  -- only the primary key is logged on DELETE
```

So when a row is deleted, the WAL entry contains only `{id: <uuid>}`. The `post_id` column is **not** in the payload, so the `post_id = <postId>` filter never matches and the event is dropped before it reaches any client.

INSERTs are unaffected because they always log the full new row.

## Fix

Set the table's replica identity to `FULL` so DELETE WAL entries include all columns:

```sql
ALTER TABLE public.comments REPLICA IDENTITY FULL;
```

After this:
- DELETE payload `oldRecord` contains every column, including `post_id`.
- Server-side filter matches; the event reaches the client.
- The existing Dart code (`payload.oldRecord['id']`) works unchanged.

This was applied as migration `comments_replica_identity_full`.

## Verification

```sql
SELECT c.relname, c.relreplident
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'public' AND c.relname = 'comments';
-- Expect relreplident = 'f' (full)
```

Manual: open the same post on two signed-in devices, delete on one, observe immediate disappearance on the other.

## Trade-offs

`REPLICA IDENTITY FULL` increases WAL size for that table because every UPDATE/DELETE now logs the full old row instead of just the PK. For `comments` (small rows, low volume) this is negligible. Avoid it on wide, high-write tables unless needed.

## When to apply this elsewhere

Any time you add a **filtered** Realtime subscription for `DELETE` (or `UPDATE` filtered on a non-PK column), the target table needs `REPLICA IDENTITY FULL`. Examples in this repo:

- ✅ `comments` — done.
- ⚠️ `posts` — currently only watches INSERT (`watchNewPosts`), so unaffected. If you ever add `watchDeletedPosts` with a filter, run `ALTER TABLE public.posts REPLICA IDENTITY FULL;`.

Unfiltered subscriptions and INSERT subscriptions do not need this change.
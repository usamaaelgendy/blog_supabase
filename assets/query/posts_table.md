create table public.posts (

id uuid primary key default gen_random_uuid(),
title text not null,
content text not null,
image_url text,
auther_id uuid not null references public.profiles(id) on delete cascade,
category text,
view_count int default 0,
created_at timestamp default now(),
updated_at timestamp default now()
);

alter table public.posts enable row level security;
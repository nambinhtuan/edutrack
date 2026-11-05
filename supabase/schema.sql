-- EduTrack schema nền tảng. Chỉ chạy trên Supabase project mới, trống.
create extension if not exists pgcrypto;
do $$ begin create type public.user_role as enum ('admin','teacher','parent');
exception when duplicate_object then null; end $$;

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 full_name text not null default '',
 role public.user_role not null default 'parent',
 is_active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.school_classes (
 id uuid primary key default gen_random_uuid(), name text not null unique,
 school_year text not null, homeroom_teacher_id uuid references public.profiles(id) on delete set null
);
create table if not exists public.subjects (
 id uuid primary key default gen_random_uuid(), name text not null unique, is_active boolean not null default true
);
create table if not exists public.students (
 id uuid primary key default gen_random_uuid(), student_code text unique,
 class_id uuid not null references public.school_classes(id) on delete restrict,
 full_name text not null, date_of_birth date,
 gender text check (gender in ('Nam','Nữ','Khác') or gender is null),
 created_at timestamptz not null default now()
);
-- Tách thông tin nhạy cảm khỏi bảng hồ sơ mà giáo viên/phụ huynh thường đọc.
create table if not exists public.student_private_details (
 student_id uuid primary key references public.students(id) on delete cascade,
 place_of_birth text, permanent_address text, citizen_id text,
 father_name text, father_phone text, mother_name text, mother_phone text, note text
);
-- Một tài khoản phụ huynh có thể liên kết nhiều con; hai số bố/mẹ có thể cùng gắn một tài khoản.
create table if not exists public.parent_student_links (
 parent_user_id uuid not null references public.profiles(id) on delete cascade,
 student_id uuid not null references public.students(id) on delete cascade,
 relationship text, primary key(parent_user_id,student_id)
);
create table if not exists public.parent_login_phones (
 phone text primary key, parent_user_id uuid not null references public.profiles(id) on delete cascade,
 is_verified boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists public.teacher_assignments (
 id uuid primary key default gen_random_uuid(),
 teacher_user_id uuid not null references public.profiles(id) on delete cascade,
 class_id uuid not null references public.school_classes(id) on delete cascade,
 subject_id uuid not null references public.subjects(id) on delete cascade,
 unique(teacher_user_id,class_id,subject_id)
);
create table if not exists public.grades (
 id uuid primary key default gen_random_uuid(),
 student_id uuid not null references public.students(id) on delete cascade,
 subject_id uuid not null references public.subjects(id) on delete restrict,
 school_year text not null, semester text not null, assessment_type text not null,
 score numeric(4,2) not null check(score between 0 and 10),
 entered_by uuid not null references public.profiles(id), updated_at timestamptz not null default now()
);
create table if not exists public.grade_audit_log (
 id uuid primary key default gen_random_uuid(), grade_id uuid, changed_by uuid,
 old_data jsonb, new_data jsonb, changed_at timestamptz not null default now()
);
create index if not exists students_class_idx on public.students(class_id);
create index if not exists grades_student_idx on public.grades(student_id);
create index if not exists assignments_teacher_idx on public.teacher_assignments(teacher_user_id);

create or replace function public.current_user_role() returns public.user_role
language sql stable security definer set search_path=public as $$
 select role from public.profiles where id=auth.uid() and is_active=true limit 1;
$$;
create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path=public as $$
 select coalesce(public.current_user_role()='admin',false);
$$;
create or replace function public.can_access_class(cid uuid) returns boolean
language sql stable security definer set search_path=public as $$
 select public.is_admin()
 or exists(select 1 from public.teacher_assignments a where a.teacher_user_id=auth.uid() and a.class_id=cid)
 or exists(select 1 from public.school_classes c where c.id=cid and c.homeroom_teacher_id=auth.uid());
$$;
create or replace function public.is_parent_of_student(sid uuid) returns boolean
language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.parent_student_links l where l.parent_user_id=auth.uid() and l.student_id=sid);
$$;

alter table public.profiles enable row level security;
alter table public.school_classes enable row level security;
alter table public.subjects enable row level security;
alter table public.students enable row level security;
alter table public.student_private_details enable row level security;
alter table public.parent_student_links enable row level security;
alter table public.parent_login_phones enable row level security;
alter table public.teacher_assignments enable row level security;
alter table public.grades enable row level security;
alter table public.grade_audit_log enable row level security;

create policy "profile self/admin read" on public.profiles for select to authenticated using(id=auth.uid() or public.is_admin());
create policy "admin manage profiles" on public.profiles for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "signed in read classes" on public.school_classes for select to authenticated using(true);
create policy "admin manage classes" on public.school_classes for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "signed in read subjects" on public.subjects for select to authenticated using(true);
create policy "admin manage subjects" on public.subjects for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "authorized read students" on public.students for select to authenticated using(public.is_admin() or public.can_access_class(class_id) or public.is_parent_of_student(id));
create policy "admin manage students" on public.students for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "admin or homeroom read private details" on public.student_private_details
for select to authenticated using (
 public.is_admin() or exists (
  select 1 from public.students s join public.school_classes c on c.id=s.class_id
  where s.id=student_private_details.student_id and c.homeroom_teacher_id=auth.uid()
 )
);
create policy "admin manage private details" on public.student_private_details
for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "own parent links" on public.parent_student_links for select to authenticated using(parent_user_id=auth.uid() or public.is_admin());
create policy "admin manage parent links" on public.parent_student_links for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "own phone links" on public.parent_login_phones for select to authenticated using(parent_user_id=auth.uid() or public.is_admin());
create policy "admin manage phone links" on public.parent_login_phones for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "own assignments" on public.teacher_assignments for select to authenticated using(teacher_user_id=auth.uid() or public.is_admin());
create policy "admin manage assignments" on public.teacher_assignments for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "authorized read grades" on public.grades for select to authenticated using(
 public.is_admin() or public.is_parent_of_student(student_id)
 or exists(select 1 from public.students s where s.id=grades.student_id and public.can_access_class(s.class_id))
);
create policy "assigned teacher insert grades" on public.grades for insert to authenticated with check(
 public.is_admin() or (entered_by=auth.uid() and exists(
  select 1 from public.students s join public.teacher_assignments a on a.class_id=s.class_id
  where s.id=grades.student_id and a.teacher_user_id=auth.uid() and a.subject_id=grades.subject_id
 ))
);
create policy "assigned teacher update grades" on public.grades for update to authenticated using(
 public.is_admin() or exists(select 1 from public.students s join public.teacher_assignments a on a.class_id=s.class_id
 where s.id=grades.student_id and a.teacher_user_id=auth.uid() and a.subject_id=grades.subject_id)
) with check(
 public.is_admin() or (entered_by=auth.uid() and exists(
  select 1 from public.students s join public.teacher_assignments a on a.class_id=s.class_id
  where s.id=grades.student_id and a.teacher_user_id=auth.uid() and a.subject_id=grades.subject_id
 ))
);
create policy "admin read audit" on public.grade_audit_log for select to authenticated using(public.is_admin());
create policy "admin insert audit" on public.grade_audit_log for insert to authenticated with check(public.is_admin());

-- Chua tao Auth user hay cap tai khoan. Luong dang nhap bang SDT va mat khau
-- chung cho SDT bo/me se duoc xay bang Edge Function an toan o giai doan tiep.

-- QUAN TRỌNG: sau khi tạo tài khoản quản trị đầu tiên trong Supabase Auth,
-- quản trị viên kỹ thuật phải tạo bản ghi profiles tương ứng với role='admin'
-- bằng môi trường quản trị an toàn. Không cấp role admin từ trình duyệt.

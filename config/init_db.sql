create table if not exists resume
(
  uuid      char(36) not null
    constraint resume_pkey
    primary key,
  full_name varchar  not null
);

create table if not exists contact
(
  id          serial   not null
    constraint contact_pkey
    primary key,
  resume_uuid char(36) not null
    constraint contact_resume_uuid_fk
    references resume
    on delete cascade,
  type        varchar  not null,
  value       varchar  not null
);

create unique index if not exists contact_uuid_type_index
  on contact (resume_uuid, type);

create table if not exists category
(
  id          serial   not null
    constraint category_pkey
    primary key,
  cresume_uuid char(36) not null
    constraint category_resume_uuid_fk
    references resume
    on delete cascade,
  ctype        varchar  not null,
  cvalue       varchar  not null
);

create unique index if not exists category_uuid_type_index
  on category (cresume_uuid, ctype);
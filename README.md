
<p align="center">
  <img src="https://img.jzxm.eu.org/guardcode/guardcode512_bw.png" width="300" />
</p>

# 护卫码

本项目适用于有一些计算机基础知识的用户.
基于Flutter+supabase在线数据库开发的,跨平台,可根据tag进行分组的二次验证器.
如果用户有自己的服务器,建议以web方式部署,方便多平台调用.
核心功能采用[otp](https://pub-web.flutter-io.cn/packages/otp)组件实现
![](https://img.jzxm.eu.org/guardcode/display.png)

## 安全性
- 采用[supabase](https://supabase.com)免费在线数据库,每个用户需要自己独立申请supabase账号,保证数据安全.
- 项目使用CS架构,客户端直连数据库,没有api服务器,数据安全.
- 每个验证器条目的key采用DES加密后保存在数据库中,用户自己设定DES加密密码,即使用户数据库泄露,只要密码不泄露,数据就安全.


## 部署方式
### 客户端
因为是跨平台,我目前只编译成web端,之后将会编译android平台的apk.其他平台会的你们可以自己编译,或等待我后续更新(短时间内估计不会编译其他平台).如果有人编译好了,也可以分享一下.

web方式部署很容易,我已经编译好了,在build/web目录下,直接上传到你的web服务器即可.
web服务器可以是nginx或者其他任意支持静态文件的服务器.具体的部署方法网络上太多,这里也不再赘述了.

需要Docker部署的,我也已经构件了nginx镜像,可以直接使用.这应该是最方便的方法了.

### 数据库
大家可以自己到supabase注册账号,然后创建一个名为"guard_code"的项目,这个项目名称应该也就是数据库的名称.
进入项目后,在左边导航到"SQL Editor"视图,这里可以执行sql语句.
运行以下sql语句进行数据库初始化:
__表:guard_code__
```sql
create table public.guard_code (
  id serial not null,
  tag_id integer null default 0,
  project text not null,
  account text not null,
  memo text null,
  logo_url text null,
  guard text not null,
  state integer not null default 1,
  created_at timestamp without time zone null default CURRENT_TIMESTAMP,
  updated_at timestamp without time zone null default CURRENT_TIMESTAMP,
  constraint guard_code_pkey primary key (id)
) TABLESPACE pg_default;
```
__表:tag__
```sql
create table public.tag (
  id serial not null,
  name text not null,
  color text null default '#95a5a6'::text,
  sort_order integer null default 0,
  created_at timestamp without time zone null default CURRENT_TIMESTAMP,
  constraint tag_pkey primary key (id),
  constraint tag_name_key unique (name),
  constraint tag_name_unique unique (name)
) TABLESPACE pg_default;
```
__表:初始化一条记录__
```sql
insert into tag (id,name) values (0,'无');
```

__函数:delete_tag 用来删除tag__
```sql
create or replace function delete_tag(p_tag_id integer)
returns void
language plpgsql
as $$
begin
  -- 检查是否存在
  if not exists (select 1 from tag where id = p_tag_id) then
    raise exception 'Tag with id % does not exist', p_tag_id;
  end if;

  -- 删除 tag
  delete from tag
  where id = p_tag_id;

  -- 更新 guard_code
  update guard_code
  set tag_id = 0
  where tag_id = p_tag_id;

end;
$$;
```

## 使用说明
首次运行可能会有错误提示弹出,主要是因为没有配置信息,可以不用理会
![](https://img.jzxm.eu.org/guardcode/first_err.png)

点击右上角齿轮按钮,弹出的菜单中选择"基本设置",进入配置页面
![](https://img.jzxm.eu.org/guardcode/base_setting.png)

主要就是3个配置:
- 密码:用来加密你项目的key,然后保存到数据库,如果你忘记了此密码,你就无法将数据库的key解密出来.
- supabase数据库连接:supabase的连接信息
- supabase数据库密钥:supabase的密钥,用于访问数据库.

supabase的连接url和密钥都可以在supabase网站中获取.
打开supabase网站,进入你的项目,然后点击顶部的"connect"按钮.
![](https://img.jzxm.eu.org/guardcode/supabase_connect.png)
之后会显示相关连接信息:
![](https://img.jzxm.eu.org/guardcode/db_connect_info.png)
注意,这里有两个密钥,publishable key应该是推荐在服务器端使用,而我们是客户端直连,所以建议使用anon key.

配置完成后,点击"保存"按钮,此时会提示是否本地存储配置信息.
公共环境强烈建议不要存储.
保存完成后返回主界面.此时就可以点击顶部的"添加"按钮,添加你的验证器了.
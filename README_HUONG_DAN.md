# EduTrack – Bộ khởi đầu

## GitHub
1. Tạo repository tên `edutrack`.
2. Giải nén ZIP.
3. Trong repository chọn Add file → Upload files.
4. Kéo thả toàn bộ NỘI DUNG thư mục `EduTrack_bo_khoi_dau` (không tải riêng ZIP).
5. Chọn Commit changes.
Ở trang chính phải thấy `index.html`, `netlify.toml`, `assets`, `supabase`.

## Supabase
1. Tạo project mới tại https://supabase.com.
2. Mở SQL Editor → New query.
3. Mở `supabase/schema.sql`, sao chép toàn bộ, dán vào SQL Editor rồi bấm Run.
4. Chỉ chạy trên project mới, trống. Nếu đã có dữ liệu/bảng thì dừng lại và hỏi trước.

## Netlify
1. Đăng nhập https://www.netlify.com.
2. Add new site → Import an existing project → GitHub.
3. Chọn repository `edutrack`.
4. Build command để trống; Publish directory nhập dấu chấm `.`.
5. Deploy site.

## Bảo mật
Không đưa dữ liệu học sinh thật vào giai đoạn này. Không đăng `service_role` key lên GitHub hoặc website. Chưa cần điền khóa Supabase vào file nào; sẽ cấu hình an toàn ở bước kế tiếp.

## Phạm vi hiện tại
Đây mới là bộ nền tảng: trang chủ mẫu và cấu trúc bảng dữ liệu có phân quyền RLS. Chưa có đăng nhập thật, nhập Excel, quản trị, sổ điểm, cấp tài khoản phụ huynh, đổi mật khẩu, nhật ký điểm tự động hoặc sao lưu. Chưa dùng cho vận hành thật.

## Lộ trình
Kết nối Supabase → đăng nhập/phân quyền → nhập Excel 12 cột → quản lý lớp/giáo viên/môn → sổ điểm theo quy chế hiện hành → kiểm thử dữ liệu giả lập.

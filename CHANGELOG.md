# Nhật ký thay đổi

## v8 – sổ điểm
- Nhập nhanh không cần dấu phẩy (85 → 8,5; 925 → 9,25; 10 → 10), tự định dạng khi rời ô/Enter, áp dụng cả khi dán từ Excel.
- Sổ điểm: nút "Tải file mẫu" và "Nhập từ Excel" (nhận diện học sinh theo Mã HS hoặc Họ tên, bỏ qua ô trống, báo lỗi từng ô, giáo viên kiểm tra rồi mới lưu).

## v7 – sửa cách khởi tạo drizzle 1.0 (nguyên nhân gốc của lỗi kết nối)

## v6 – health gọi thẳng Neon (directCheck)

## v5 – chẩn đoán kết nối Neon
- Tự làm sạch chuỗi DATABASE_URL (bỏ psql, dấu nháy, channel_binding); trang /api/health hiện lỗi chi tiết và kiểm tra dạng chuỗi.

## v4 – sửa lỗi "Không kết nối được máy chủ"
- Gỡ `typescript@7` (bản native mới, có thể không tương thích bộ biên dịch của Vercel); Vercel dùng bộ biên dịch riêng.
- Chuyển `auth.ts` ra thư mục `lib/` (mọi file trong `api/` bị Vercel coi là một hàm máy chủ).
- Kết nối database tạo khi cần; thêm trang chẩn đoán `/api/health`; thông báo lỗi chỉ rõ nguyên nhân.

## v2 – rà soát bảo mật & độ tin cậy
**Bảo mật**
- Bắt buộc đổi mật khẩu cho tài khoản dùng mật khẩu do hệ thống cấp (chặn ở cả máy chủ lẫn giao diện).
- Mật khẩu người dùng tự đặt tối thiểu 8 ký tự (trước là 6).
- Khởi tạo đơn giản: người đầu tiên vào website tự thành Quản trị hệ thống (không cần mã); chống tạo 2 admin do bấm đồng thời.
- Chống CSRF thêm lớp: bắt buộc `Content-Type: application/json` và từ chối `Sec-Fetch-Site` cross-site.
- Phản hồi API luôn `Cache-Control: no-store`.
- Đăng nhập: cân bằng thời gian phản hồi khi tên đăng nhập không tồn tại.
- Phân quyền: giáo viên có quyền quản trị không còn cấp lại được mật khẩu của quản trị viên khác; `PUT /api/teachers/:id` chỉ áp dụng cho giáo viên/quản trị; không thể tự khoá chính mình.
- Thêm các header: CSP, HSTS, Permissions-Policy.

**Độ tin cậy**
- Nhập Excel chia lượt 100 dòng (tránh quá thời gian), `maxDuration` 60s.
- Mã HS tự sinh có tính xác định (họ tên + ngày sinh) → nhập lại không tạo học sinh trùng.
- Lưu điểm: loại bỏ ô trùng trong cùng yêu cầu (tránh lỗi 500).
- Kiểm tra lớp tồn tại khi thêm/sửa học sinh; sửa học sinh không tồn tại trả 404.
- Báo lỗi rõ ràng khi thiếu `DATABASE_URL`; dọn phiên hết hạn; truy vấn phiên chạy song song.
- UI: ẩn nút xoá tài khoản phụ huynh với người không đủ quyền.

**Tài liệu**: cập nhật README, thêm `.env.example`, siết `.gitignore`.

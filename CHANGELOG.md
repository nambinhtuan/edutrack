# Nhật ký thay đổi

## v2 – rà soát bảo mật & độ tin cậy
**Bảo mật**
- Bắt buộc đổi mật khẩu cho tài khoản dùng mật khẩu do hệ thống cấp (chặn ở cả máy chủ lẫn giao diện).
- Mật khẩu người dùng tự đặt tối thiểu 8 ký tự (trước là 6).
- Biến `SETUP_KEY` (tuỳ chọn, khuyến nghị) bảo vệ bước khởi tạo Quản trị hệ thống; chống tạo 2 admin do bấm đồng thời.
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

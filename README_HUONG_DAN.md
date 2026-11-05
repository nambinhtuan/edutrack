# EduTrack – Bộ khởi đầu có kiểm tra kết nối Supabase

## 1. Điền cấu hình Supabase
1. Mở `assets/supabase-config.js` bằng Notepad hoặc VS Code.
2. Thay `DAN_PROJECT_URL_VAO_DAY` bằng Project URL lấy trong Supabase.
3. Thay `DAN_PUBLISHABLE_KEY_VAO_DAY` bằng Publishable key (hoặc anon key cũ).
4. Giữ nguyên dấu ngoặc kép và không xóa dấu chấm phẩy cuối dòng.
5. Không dùng `service_role` hoặc `secret key`.

## 2. Cập nhật GitHub
1. Mở repository `edutrack` trên GitHub.
2. Chọn Add file → Upload files.
3. Giải nén ZIP và tải lên toàn bộ nội dung bên trong thư mục `EduTrack_bo_khoi_dau` (không tải file ZIP).
4. Nếu GitHub hỏi ghi đè các file đã có, chấp nhận cập nhật.
5. Nhấn Commit changes.

## 3. Kiểm tra Netlify
Netlify thường tự triển khai lại sau khi GitHub có commit mới. Mở website, tải lại trang (Ctrl+F5). Trong mục “Trạng thái hệ thống” cần thấy: “Đã kết nối được tới Supabase”.

## Bảo mật và phạm vi
- Project URL và Publishable/anon key là thông tin dùng ở trình duyệt; chúng không thay thế bảo mật RLS.
- Tuyệt đối không đưa `service_role` hoặc `secret key` vào website/GitHub.
- Chưa tải dữ liệu học sinh thật lên hệ thống.
- Bản này chỉ kiểm tra kết nối tới Supabase Auth; chưa có đăng nhập, quản trị, nhập Excel, sổ điểm hoặc phân quyền giao diện. Cần xây dựng và kiểm thử các chức năng đó trước khi vận hành thật.

# EduTrack – Quản lý điểm THCS (Thông tư 22/2021/TT-BGDĐT)

Chạy trên **Vercel** (miễn phí) + cơ sở dữ liệu **Neon** (miễn phí). Chỉ cần làm **4 bước**, không cần biết lập trình.

## Bước 1 – Tạo database (2 phút)
1. Vào https://neon.tech → đăng nhập bằng Google → **Create project** (vùng *Singapore*).
2. Bấm **Connect**, **copy** chuỗi bắt đầu bằng `postgresql://...` rồi dán tạm vào Notepad.

## Bước 2 – Đưa mã lên GitHub (3 phút)
1. Vào https://github.com/new → đặt tên `edutrack` → chọn **Private** → **Create repository**.
2. Giải nén file ZIP, vào trang repository vừa tạo → bấm **uploading an existing file**.
3. Mở thư mục đã giải nén, **chọn tất cả file và thư mục bên trong** (api, db, migrations, public, vercel.json, package.json, .gitignore…) rồi kéo thả vào GitHub → bấm **Commit changes**.

## Bước 3 – Đưa lên mạng bằng Vercel (3 phút)
1. Vào https://vercel.com → đăng nhập bằng GitHub → **Add New → Project** → **Import** repository `edutrack`.
2. Mở mục **Environment Variables**: ô *Name* gõ `DATABASE_URL`, ô *Value* dán chuỗi đã copy ở Bước 1 → **Add**.
3. Bấm **Deploy**, chờ 1–2 phút. Xong sẽ có đường link dạng `https://edutrack-xxxx.vercel.app`.

## Bước 4 – Tạo tài khoản của bạn (1 phút)
Mở đường link ngay sau khi deploy xong. **Người đầu tiên vào là Quản trị hệ thống**: nhập tên đăng nhập (đã điền sẵn `admin`) và mật khẩu từ 8 ký tự → bấm **Tạo tài khoản và vào hệ thống**. Hãy tự làm bước này ngay, đừng gửi link cho ai trước khi tạo xong.

---

## Sử dụng lần đầu (làm theo thứ tự)
1. **Môn học** → bấm *Tạo 12 môn THCS chuẩn*.
2. **Giáo viên & phân công** → *Thêm giáo viên* (chép mật khẩu hiện ra, gửi cho thầy/cô) → *Phân công* môn và lớp.
3. **Hồ sơ học sinh** → *Tải file Excel mẫu* → điền danh sách → *Nhập từ Excel*. Hệ thống tự tạo lớp và tài khoản phụ huynh (đăng nhập bằng số điện thoại). Bấm *Tải danh sách tài khoản* để in phát cho phụ huynh.
4. **Quản lý lớp** → chọn giáo viên chủ nhiệm cho từng lớp.

Mật khẩu hệ thống cấp cho giáo viên và phụ huynh chỉ dùng được một lần: họ sẽ được yêu cầu đặt mật khẩu mới ngay khi đăng nhập lần đầu.

## Nhập điểm nhanh và nhập điểm bằng Excel (dành cho giáo viên)
**Gõ nhanh, không cần dấu phẩy:** trong *Sổ điểm*, gõ `85` → hiển thị `8,5`; gõ `925` → `9,25`; gõ `7` → `7`; gõ `10` (hoặc `100`) → `10`. Nhấn Enter để xuống ô dưới. Vẫn có thể gõ đầy đủ `8,5` hoặc `9.25`. Quy tắc: 1 chữ số = điểm nguyên; 2 chữ số = một chữ số thập phân; 3 chữ số = hai chữ số thập phân (riêng `10`, `100` là 10 điểm). Muốn nhập 1,0 hãy gõ `1`.

**Nhập bằng Excel:** chọn lớp, môn, học kỳ → bấm **Tải file mẫu** (có sẵn danh sách học sinh) → điền điểm vào các cột TX1, TX2…, GK, CK (ô Excel ghi `85` cũng được hiểu là 8,5) → bấm **Nhập từ Excel** và chọn file. Hệ thống điền vào bảng điểm và báo ô nào không hợp lệ hoặc học sinh nào không tìm thấy; giáo viên kiểm tra rồi bấm **Lưu điểm**. Ô để trống được bỏ qua (không xoá điểm đã có). Môn nhận xét: điền `Đ` hoặc `CĐ` (hoặc `1`/`0`).

## Khi cần
* **Cập nhật phiên bản mới:** vào GitHub → *Add file → Upload files* và chép đè file mới; Vercel tự cập nhật, dữ liệu vẫn giữ nguyên.
* **Quên mật khẩu giáo viên/phụ huynh:** *Giáo viên & phân công* hoặc *Tài khoản phụ huynh* → *Cấp lại MK*.
* **Quên mật khẩu Quản trị hệ thống:** vào Neon → *SQL Editor* → chạy `DELETE FROM users WHERE is_super_admin = true;` rồi mở lại website để tạo tài khoản mới.
* **Báo "Không kết nối được máy chủ" hoặc lỗi 500:** mở đường link của bạn rồi thêm `/api/health` vào cuối (ví dụ `https://edutrack-xxxx.vercel.app/api/health`). Trang này cho biết bằng tiếng Việt thiếu `DATABASE_URL`, sai chuỗi kết nối, hay chưa tạo được bảng. Sửa xong vào *Deployments → ⋯ → Redeploy*. Nếu trang đó báo 404, vào Vercel → *Deployments* → bản mới nhất → *Build Logs* và gửi ảnh chụp để được hỗ trợ.
* **Nút Excel không hoạt động:** gửi ảnh chụp màn hình lỗi để được hỗ trợ.
* **Sao lưu:** cuối mỗi học kỳ nên xuất Excel sổ điểm từng lớp để lưu.

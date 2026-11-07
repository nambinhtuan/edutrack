# EduTrack – Quản lý điểm THCS (Chuẩn Thông tư 22/2021/TT-BGDĐT)

Website triển khai trên **Vercel** (Serverless + Frontend) kết hợp **Neon.tech** (PostgreSQL Serverless đám mây).
- **Frontend**: Giao diện thuần HTML5, CSS3, JavaScript ES Modules trong thư mục `public/`.
- **Backend**: Vercel Serverless Function trong `api/index.ts`.
- **Cơ sở dữ liệu**: PostgreSQL đám mây trên Neon.tech qua Drizzle ORM (`db/schema.ts`, `migrations/`). Dữ liệu được bảo toàn vĩnh viễn độc lập, không lo mất mát khi nâng cấp code.

---

## 🚀 Hướng dẫn triển khai chi tiết từ A đến Z (Hoàn toàn miễn phí)

### BƯỚC 1: Tạo Database trên Neon.tech (Mất 2 phút)
1. Truy cập [https://neon.tech](https://neon.tech) và chọn **Sign up** (có thể đăng nhập nhanh bằng tài khoản Google hoặc GitHub).
2. Sau khi đăng nhập, chọn **Create project**:
   - Project name: Đặt tên tuỳ ý (ví dụ: `edutrack-db`).
   - Region: Chọn vùng gần Việt Nam (ví dụ: `Singapore` - `ap-southeast-1` để tải nhanh nhất).
   - Bấm **Create project**.
3. Tại trang tổng quan Dashboard của Neon, tìm mục **Connection string** (dạng `postgres://...` hoặc `postgresql://...`).
4. Nhấp nút **Copy** chuỗi kết nối này. Đây chính là giá trị của biến `DATABASE_URL`.

---

### BƯỚC 2: Đưa mã nguồn lên GitHub
1. Giải nén file ZIP `edutrack-hoan-thien.zip`.
2. Mở GitHub, tạo repository mới (ví dụ đặt tên là `edutrack`), chọn chế độ **Public** hoặc **Private**.
3. Chọn **Add file** → **Upload files**.
4. Kéo thả **toàn bộ nội dung bên trong** thư mục vừa giải nén lên GitHub:
   - Các thư mục: `api`, `db`, `migrations`, `public`
   - Các file: `package.json`, `package-lock.json`, `vercel.json`, `drizzle.config.ts`, `.gitignore`, `README_HUONG_DAN.md`
5. Chọn **"Commit directly to the main branch"** và bấm **Commit changes**.

---

### BƯỚC 3: Triển khai trên Vercel
1. Truy cập [https://vercel.com](https://vercel.com) và đăng nhập bằng tài khoản **GitHub**.
2. Tại bảng điều khiển Dashboard, bấm **Add New...** → **Project**.
3. Chọn repository `edutrack` bạn vừa tải lên và bấm **Import**.
4. Tại màn hình cấu hình dự án (*Configure Project*):
   - **Framework Preset**: Để nguyên `Other`.
   - Mở mục **Environment Variables** (Biến môi trường):
     - **Key (Tên biến)**: Nhập chính xác chữ: `DATABASE_URL`
     - **Value (Giá trị)**: Dán chuỗi kết nối Neon bạn đã copy ở **Bước 1**.
     - Bấm nút **Add**.
5. Bấm nút **Deploy**.
6. Vercel sẽ tự động cài đặt thư viện, chạy lệnh migrate tạo toàn bộ các bảng trong cơ sở dữ liệu Neon, và cấp cho bạn một đường link tên miền miễn phí (ví dụ: `https://edutrack-xxx.vercel.app`).

---

### BƯỚC 4: Khởi tạo hệ thống lần đầu
1. Mở đường link website Vercel vừa cấp.
2. Màn hình **Khởi tạo hệ thống** sẽ xuất hiện lần đầu tiên:
   - Nhập họ tên của bạn (Quản trị hệ thống).
   - Nhập tên đăng nhập và mật khẩu quản trị.
   - Bấm **Tạo tài khoản Quản trị hệ thống**.
3. Vào mục **Môn học**, bấm nút **Tạo 12 môn THCS chuẩn (CT GDPT 2018)** để hệ thống tự điền sẵn các môn chuẩn theo Thông tư 22.

---

## 🌟 Hướng dẫn sử dụng các tính năng chính

### 1. Phân quyền Quản trị cho Giáo viên
* Bạn là **Quản trị hệ thống** (quyền cao nhất).
* Để giao quyền quản trị cho giáo viên khác (hỗ trợ tạo lớp, thêm học sinh, phân công...):
  1. Vào menu **Giáo viên & phân công**.
  2. Bấm nút **Sửa** cạnh tên giáo viên đó.
  3. Tích chọn: `☑ Cấp quyền quản trị viên (hỗ trợ thêm lớp, học sinh, phân công...)`.
  4. Bấm **Lưu**. Khi giáo viên đó đăng nhập sẽ có đầy đủ các quyền quản trị như một Quản trị viên.

### 2. Sổ điểm theo Thông tư 22/2021/TT-BGDĐT
* **Môn đánh giá bằng nhận xét (Thể dục, Nghệ thuật, HĐTN-HN, GDĐP)**:
  * Giáo viên có thể nhập: `Đ` (hoặc `1`, `D`, `Đạt`) hoặc `CĐ` (hoặc `0`, `CD`, `Chưa đạt`).
  * Hệ thống tự động chuẩn hóa và hiển thị huy hiệu `Đạt` (xanh) hoặc `Chưa đạt` (đỏ cam).
  * Đánh giá cả năm: Học kỳ II Đạt $\rightarrow$ Cả năm Đạt (`Đ`).
* **Môn đánh giá bằng điểm số (Toán, Văn, Anh, KHTN...)**:
  * Nhập điểm từ 0 đến 10 (hỗ trợ cả dấu chấm `8.5` và dấu phẩy `8,5`).
  * Tự động tính điểm trung bình học kỳ theo công thức:
    $$\text{ĐTB}_{\text{mhk}} = \frac{\sum \text{ĐĐG}_{\text{tx}} + 2 \times \text{ĐĐG}_{\text{gk}} + 3 \times \text{ĐĐG}_{\text{ck}}}{\text{Số ĐĐG}_{\text{tx}} + 5}$$
* **Hỗ trợ dán (paste) từ Excel**: Giáo viên có thể copy một cột hoặc cả bảng điểm từ file Excel của mình và dán (`Ctrl+V`) thẳng vào ô điểm đầu tiên trên web.

### 3. Nhập học sinh & Tự động tạo tài khoản phụ huynh
* Vào mục **Hồ sơ học sinh** → bấm **Nhập từ Excel**.
* Hệ thống tự động nhận diện nhiều dạng tên cột tiếng Việt (*Mã HS, Họ tên, Lớp, Ngày sinh, SĐT bố, SĐT mẹ...*).
* Tự động cấp tài khoản phụ huynh bằng **Số điện thoại** với mật khẩu dễ nhớ: `tên con (không dấu) + ngày sinh dạng ddmm` (ví dụ: học sinh Hà Văn Bằng sinh ngày 21/03/2015 $\rightarrow$ mật khẩu là `bang2103`).
* Sau khi nhập, bạn có thể tải file Excel danh sách tài khoản để in và gửi cho phụ huynh.

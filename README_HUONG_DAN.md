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
Cách nhanh nhất (dòng lệnh, giữ được toàn bộ file ẩn như `.gitignore`):
```bash
unzip edutrack-vercel-neon-v2.zip -d edutrack && cd edutrack
git init -b main
git add .
git commit -m "EduTrack v2"
git remote add origin https://github.com/<tên-bạn>/edutrack.git
git push -u origin main
```
Hoặc dùng giao diện web: tạo repository trống → **Add file → Upload files** → kéo thả **toàn bộ nội dung bên trong** thư mục đã giải nén (nhớ cả file `.gitignore`, `.env.example`).
> ⚠️ Không bao giờ commit file `.env` hoặc chuỗi kết nối Neon lên GitHub, kể cả repository Private.

---

### BƯỚC 3: Triển khai trên Vercel
1. Truy cập [https://vercel.com](https://vercel.com) và đăng nhập bằng tài khoản **GitHub**.
2. **Add New... → Project** → chọn repository `edutrack` → **Import**.
3. Tại *Configure Project*: **Framework Preset** để `Other`; mở **Environment Variables** và thêm:
   - `DATABASE_URL` = chuỗi kết nối Neon ở Bước 1.
   - `SETUP_KEY` = một chuỗi bí mật bạn tự đặt (khuyến nghị, ví dụ 16 ký tự ngẫu nhiên). Sẽ được hỏi khi khởi tạo hệ thống lần đầu.
4. Bấm **Deploy**. Vercel chạy migrate để tạo bảng trong Neon, rồi cấp link dạng `https://edutrack-xxx.vercel.app`.

**Lưu ý quan trọng về môi trường Preview:** mỗi lần build, hệ thống chạy migrate trên database ở `DATABASE_URL`. Nếu bạn dùng cùng một `DATABASE_URL` cho cả *Production* và *Preview*, các nhánh thử nghiệm sẽ tác động lên dữ liệu thật. Nên tạo một **branch database** riêng trên Neon cho Preview và đặt `DATABASE_URL` khác nhau theo từng môi trường (Vercel → Settings → Environment Variables → chọn môi trường).

---

### BƯỚC 4: Khởi tạo hệ thống lần đầu
1. Mở đường link website Vercel vừa cấp.
2. Màn hình **Khởi tạo hệ thống** sẽ xuất hiện lần đầu tiên:
   - Nhập họ tên của bạn (Quản trị hệ thống).
   - Nhập tên đăng nhập và mật khẩu quản trị (ít nhất 8 ký tự).
   - Nhập **Mã khởi tạo** (chính là `SETUP_KEY` đã khai báo ở Bước 3, nếu có).
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
* Tự động cấp tài khoản phụ huynh bằng **Số điện thoại** với mật khẩu ban đầu dễ nhớ (phụ huynh **bắt buộc đổi** ngay lần đăng nhập đầu tiên): `tên con (không dấu) + ngày sinh dạng ddmm` (ví dụ: học sinh Hà Văn Bằng sinh ngày 21/03/2015 $\rightarrow$ mật khẩu là `bang2103`).
* Sau khi nhập, bạn có thể tải file Excel danh sách tài khoản để in và gửi cho phụ huynh.

### 4. Nhập file lớn
Giao diện tự chia file Excel thành từng lượt 100 học sinh để không vượt thời gian tối đa của máy chủ. Khi **Mã HS để trống** nhưng có **Ngày sinh**, hệ thống sinh mã cố định theo *họ tên + ngày sinh*, nên nhập lại cùng file hoặc nhập danh sách năm sau sẽ **cập nhật** đúng học sinh cũ (giữ nguyên điểm), không tạo bản sao.

---

## 🔐 Lưu ý bảo mật & vận hành
* Dữ liệu điểm, số điện thoại, địa chỉ của học sinh (trẻ em) là **dữ liệu cá nhân** – chỉ cấp quyền quản trị cho người thật sự cần, và thông báo cho phụ huynh về mục đích sử dụng.
* Mật khẩu hệ thống cấp (giáo viên, phụ huynh) đều bắt buộc đổi ở lần đăng nhập đầu.
* **Sao lưu:** định kỳ (cuối mỗi học kỳ) xuất file Excel từng lớp/môn từ mục *Sổ điểm*, và kiểm tra thời gian lưu lịch sử khôi phục (restore window) của gói Neon bạn đang dùng.
* Thư viện đọc/ghi Excel (SheetJS) được tải từ `cdn.sheetjs.com`. Nếu muốn chạy hoàn toàn độc lập, hãy tải file `xlsx.mjs` về thư mục `public/assets/` và sửa hàm `loadXLSX()` trong `app.js` (rồi bỏ các domain CDN khỏi `Content-Security-Policy` trong `vercel.json`).

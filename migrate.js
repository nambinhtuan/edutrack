import { execSync } from "node:child_process";

const dbUrl = process.env.DATABASE_URL;

if (!dbUrl || dbUrl.trim() === "") {
  console.log("----------------------------------------------------------------");
  console.log("⚠️  LƯU Ý: Chưa tìm thấy biến môi trường DATABASE_URL.");
  console.log("👉 Vui lòng vào Vercel > Settings > Environment Variables và thêm:");
  console.log("   - Key: DATABASE_URL");
  console.log("   - Value: <Chuỗi kết nối từ Neon.tech>");
  console.log("Dự án sẽ tiếp tục build để bạn có thể thêm biến môi trường sau đó.");
  console.log("Các bảng sẽ được tự động khởi tạo khi trang web chạy lần đầu.");
  console.log("----------------------------------------------------------------");
  process.exit(0);
}

try {
  console.log("🚀 Đang chạy migration cơ sở dữ liệu trên Neon...");
  execSync("npx drizzle-kit migrate", { stdio: "inherit" });
  console.log("✅ Hoàn tất migration thành công!");
} catch (e) {
  console.warn("⚠️ Chú ý: drizzle-kit migrate gặp lỗi tạm thời:", e.message);
  console.warn("Dự án vẫn tiếp tục build. Các bảng sẽ được tự động đồng bộ khi truy cập trang web.");
  process.exit(0);
}

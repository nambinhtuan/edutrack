import { neon } from "@neondatabase/serverless";
import { drizzle, type NeonHttpDatabase } from "drizzle-orm/neon-http";
import * as schema from "./schema.js";

// Kết nối được tạo khi có yêu cầu đầu tiên (không phải lúc nạp file) để nếu thiếu DATABASE_URL
// máy chủ vẫn chạy và báo lỗi dễ hiểu thay vì "sập" không rõ nguyên nhân.
// Làm sạch chuỗi kết nối người dùng dán vào: bỏ chữ "psql", dấu nháy, khoảng trắng, tham số channel_binding.
export function cleanDatabaseUrl(raw: string): string {
  const m = raw.match(/postgres(?:ql)?:\/\/[^\s'"]+/i);
  let u = m ? m[0] : raw.trim();
  u = u.replace(/([?&])channel_binding=[^&]*&?/i, "$1").replace(/[?&]$/, "");
  return u;
}

let instance: NeonHttpDatabase<typeof schema> | null = null;
function getDb(): NeonHttpDatabase<typeof schema> {
  if (!instance) {
    const url = cleanDatabaseUrl(process.env.DATABASE_URL || "");
    if (!url) throw new Error("Thiếu biến môi trường DATABASE_URL");
    // drizzle 1.0 nhận tham số dạng đối tượng { client, schema } (cách gọi cũ drizzle(client, {schema}) không còn đúng).
    instance = drizzle({ client: neon(url), schema });
  }
  return instance;
}

export const db = new Proxy({} as NeonHttpDatabase<typeof schema>, {
  get(_target, prop) {
    const real = getDb() as any;
    const value = real[prop];
    return typeof value === "function" ? value.bind(real) : value;
  },
});

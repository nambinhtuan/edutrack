import { neon } from "@neondatabase/serverless";
import { drizzle } from "drizzle-orm/neon-http";
import * as schema from "./schema.js";

let _db: ReturnType<typeof drizzle> | null = null;

export function getDb() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString || connectionString.trim() === "") {
    throw new Error(
      "Chưa có biến môi trường DATABASE_URL trên Vercel. " +
      "Vui lòng vào Vercel > Settings > Environment Variables để thêm DATABASE_URL từ Neon.tech, sau đó chọn Redeploy."
    );
  }
  if (!_db) {
    const sql = neon(connectionString);
    _db = drizzle(sql, { schema });
  }
  return _db;
}

// Proxy để khởi tạo database lười (lazy-load), tránh lỗi crash module khi chưa có DATABASE_URL
export const db = new Proxy({} as ReturnType<typeof drizzle>, {
  get(_target, prop) {
    const instance = getDb();
    const val = (instance as any)[prop];
    return typeof val === "function" ? val.bind(instance) : val;
  },
});

import { neon } from "@neondatabase/serverless";
import { drizzle } from "drizzle-orm/neon-http";
import * as schema from "./schema.js";

const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  throw new Error("Thiếu biến môi trường DATABASE_URL. Hãy khai báo chuỗi kết nối Neon trong Vercel → Settings → Environment Variables.");
}
const sql = neon(connectionString);
export const db = drizzle(sql, { schema });

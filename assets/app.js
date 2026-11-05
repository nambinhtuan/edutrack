import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY } from "./supabase-config.js";

const statusEl = document.getElementById("status");
const noteEl = document.querySelector(".note");
const isConfigured =
  SUPABASE_URL.startsWith("https://") &&
  !SUPABASE_URL.includes("DAN_PROJECT_URL") &&
  SUPABASE_PUBLISHABLE_KEY.length > 20 &&
  !SUPABASE_PUBLISHABLE_KEY.includes("DAN_PUBLISHABLE_KEY");

if (!isConfigured) {
  statusEl.textContent = "Chưa cấu hình Supabase. Hãy điền Project URL và Publishable key trong assets/supabase-config.js.";
} else {
  const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);
  window.eduTrackSupabase = supabase;
  statusEl.textContent = "Đang kiểm tra kết nối Supabase…";
  fetch(`${SUPABASE_URL}/auth/v1/settings`, {
    headers: { apikey: SUPABASE_PUBLISHABLE_KEY }
  })
    .then(async (response) => {
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      await response.json();
      statusEl.textContent = "Đã kết nối được tới Supabase. Chưa đăng nhập – các chức năng quản lý sẽ được xây dựng ở bước tiếp theo.";
      if (noteEl) noteEl.textContent = "Kết nối Supabase đã hoạt động. Đây vẫn là bản nền tảng; chưa có màn hình đăng nhập, nhập Excel hoặc quản lý điểm.";
    })
    .catch((error) => {
      console.error("EduTrack Supabase connection error:", error);
      statusEl.textContent = "Chưa kết nối được Supabase. Hãy kiểm tra lại Project URL, Publishable key và trạng thái dự án.";
    });
}

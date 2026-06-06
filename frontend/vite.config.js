import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000, 
    proxy: {
      // Whenever the frontend fetches something starting with "/api",
      // Vite will proxy it to the backend container/server locally.
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
        secure: false,
      },
    },
  },
})
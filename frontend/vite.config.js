import { defineConfig, loadEnv } from 'vite';
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  return {
    server: {
      port: 5173, strictPort: true,
      proxy: {
        '/favorites': { target: env.BACKEND_URL || 'http://localhost:8080', changeOrigin: true },
        '/solved': { target: env.BACKEND_URL || 'http://localhost:8080', changeOrigin: true },
        '/errors': { target: env.BACKEND_URL || 'http://localhost:8080', changeOrigin: true },
        '/api': { target: env.BACKEND_URL || 'http://localhost:8080', changeOrigin: true }
      }
    }
  };
});

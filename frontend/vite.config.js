import { defineConfig, loadEnv } from 'vite';
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '');
  return {
    server: {
      port: 5173, strictPort: true,
      proxy: { '/errors': { target: env.BACKEND_URL || 'http://localhost:8080', changeOrigin: true } }
    }
  };
});
